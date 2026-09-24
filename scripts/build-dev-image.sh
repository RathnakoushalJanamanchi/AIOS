#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_DIR="${AIOS_BUILD_DIR:-$ROOT/build/dev-image-work}"
ARTIFACT_DIR="${AIOS_ARTIFACT_DIR:-$ROOT/build/artifacts}"
IMAGE_NAME="FreeBSD-15.1-RELEASE-amd64-BASIC-CLOUDINIT-ufs.qcow2.xz"
BASE_URL="https://download.freebsd.org/releases/VM-IMAGES/15.1-RELEASE/amd64/Latest"
BASE_SHA512="bea82b91a983a20eb7ecdc6f11c1006d394ebbc5668b7f0ecdecf5a54fc5f9ea3a8384fc9f74a6611a9b08c183fa953327147ebfaa0de199fd015e67dd1e608a"

require_command() {
    command -v "$1" >/dev/null 2>&1 || {
        echo "Required command not found: $1" >&2
        exit 2
    }
}

for command_name in curl sha512sum xz qemu-img qemu-system-x86_64 cloud-localds ssh ssh-keygen base64; do
    require_command "$command_name"
done

mkdir -p "$WORK_DIR" "$ARTIFACT_DIR"
ARCHIVE="$WORK_DIR/$IMAGE_NAME"
BASE_IMAGE="$WORK_DIR/freebsd-base.qcow2"
DISK_IMAGE="$WORK_DIR/indian-aios-dev-work.qcow2"
SEED_ISO="$WORK_DIR/cloud-init.iso"
SERIAL_LOG="$WORK_DIR/qemu-serial.log"
KEY_FILE="$WORK_DIR/ci-ed25519"
USER_DATA="$WORK_DIR/user-data.yaml"
META_DATA="$WORK_DIR/meta-data"
ARTIFACT_IMAGE="$ARTIFACT_DIR/indian-aios-dev.qcow2"

if [[ ! -f "$ARCHIVE" ]]; then
    curl --fail --location --retry 4 --retry-delay 2 "$BASE_URL/$IMAGE_NAME" -o "$ARCHIVE"
fi
printf '%s  %s\n' "$BASE_SHA512" "$ARCHIVE" | sha512sum --check --status || {
    echo "FreeBSD base image SHA-512 mismatch: $ARCHIVE" >&2
    exit 1
}

if [[ ! -f "$BASE_IMAGE" ]]; then
    xz --decompress --stdout "$ARCHIVE" > "$BASE_IMAGE.tmp"
    mv "$BASE_IMAGE.tmp" "$BASE_IMAGE"
fi

rm -f "$DISK_IMAGE" "$SEED_ISO" "$SERIAL_LOG" "$ARTIFACT_IMAGE"
qemu-img create -f qcow2 -F qcow2 -b "$BASE_IMAGE" "$DISK_IMAGE" >/dev/null

ssh-keygen -q -t ed25519 -N "" -C "indian-aios-ci" -f "$KEY_FILE"
PUBLIC_KEY="$(cat "$KEY_FILE.pub")"
PACKAGE_LIST="$(awk '!/^[[:space:]]*(#|$)/ {printf "%s ", $1}' "$ROOT/build/packages.txt")"
sed "s|__AIOS_PACKAGE_LIST__|$PACKAGE_LIST|" "$ROOT/build/cloud-init/bootstrap.sh" > "$WORK_DIR/bootstrap.sh"
BOOTSTRAP_B64="$(base64 --wrap=0 "$WORK_DIR/bootstrap.sh")"
SMOKE_B64="$(base64 --wrap=0 "$ROOT/build/cloud-init/smoke-test.sh")"
sed \
    -e "s|__AIOS_SSH_PUBLIC_KEY__|$PUBLIC_KEY|" \
    -e "s|__AIOS_BOOTSTRAP_B64__|$BOOTSTRAP_B64|" \
    -e "s|__AIOS_SMOKE_B64__|$SMOKE_B64|" \
    "$ROOT/build/cloud-init/user-data.yaml.in" > "$USER_DATA"
cat > "$META_DATA" <<'EOF'
instance-id: iid-indian-aios-dev-01
local-hostname: indian-aios-dev
EOF
cloud-localds "$SEED_ISO" "$USER_DATA" "$META_DATA"

QEMU_ACCEL=(-accel tcg,thread=multi)
if [[ -r /dev/kvm && -w /dev/kvm ]]; then
    QEMU_ACCEL=(-accel kvm)
fi
QEMU_DISPLAY=(-display none)
if [[ "${AIOS_QEMU_HEADLESS:-1}" != "1" ]]; then
    QEMU_DISPLAY=()
fi
QEMU_CPUS="${AIOS_QEMU_CPUS:-4}"
QEMU_MEMORY="${AIOS_QEMU_MEMORY:-4096}"
SSH_PORT="${AIOS_SSH_PORT:-2222}"
QEMU_PID=""

cleanup() {
    if [[ -n "$QEMU_PID" ]] && kill -0 "$QEMU_PID" 2>/dev/null; then
        kill "$QEMU_PID" 2>/dev/null || true
        wait "$QEMU_PID" 2>/dev/null || true
    fi
    rm -f "$KEY_FILE" "$KEY_FILE.pub"
}
trap cleanup EXIT

qemu-system-x86_64 \
    "${QEMU_ACCEL[@]}" \
    -machine q35 -cpu max -smp "$QEMU_CPUS" -m "$QEMU_MEMORY" \
    -drive "file=$DISK_IMAGE,if=virtio,format=qcow2" \
    -drive "file=$SEED_ISO,media=cdrom,readonly=on" \
    -netdev "user,id=net0,hostfwd=tcp:127.0.0.1:$SSH_PORT-:22" \
    -device virtio-net-pci,netdev=net0 \
    -vga std "${QEMU_DISPLAY[@]}" \
    -monitor none -serial "file:$SERIAL_LOG" \
    > "$WORK_DIR/qemu-stderr.log" 2>&1 &
QEMU_PID=$!

SSH_OPTIONS=(-i "$KEY_FILE" -p "$SSH_PORT" -o BatchMode=yes -o ConnectTimeout=5 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null)
guest_ssh() {
    ssh "${SSH_OPTIONS[@]}" "aios@127.0.0.1" "$@"
}

echo "Waiting for the FreeBSD guest and cloud-init provisioning..."
SSH_READY=0
for _ in $(seq 1 180); do
    if guest_ssh true >/dev/null 2>&1; then
        SSH_READY=1
        break
    fi
    if ! kill -0 "$QEMU_PID" 2>/dev/null; then
        cat "$WORK_DIR/qemu-stderr.log" >&2 || true
        cat "$SERIAL_LOG" >&2 || true
        exit 1
    fi
    sleep 5
done
if [[ "$SSH_READY" != "1" ]]; then
    echo "Timed out waiting for SSH. QEMU serial output:" >&2
    cat "$SERIAL_LOG" >&2 || true
    exit 1
fi

BOOTSTRAP_READY=0
for _ in $(seq 1 180); do
    if guest_ssh "test -f /var/run/aios-bootstrap.done" >/dev/null 2>&1; then
        BOOTSTRAP_READY=1
        break
    fi
    if guest_ssh "test -f /var/run/aios-bootstrap.failed" >/dev/null 2>&1; then
        echo "Guest package provisioning failed:" >&2
        guest_ssh "cat /var/run/aios-bootstrap.failed; tail -n 100 /var/log/cloud-init-output.log" >&2 || true
        exit 1
    fi
    sleep 10
done
if [[ "$BOOTSTRAP_READY" != "1" ]]; then
    echo "Timed out waiting for package provisioning." >&2
    guest_ssh "tail -n 100 /var/log/cloud-init-output.log" >&2 || true
    cat "$SERIAL_LOG" >&2 || true
    exit 1
fi

guest_ssh "sh /root/aios-smoke-test.sh"
guest_ssh "pkg info -a" > "$ARTIFACT_DIR/package-manifest.txt"
guest_ssh "freebsd-version -kru; uname -a" > "$ARTIFACT_DIR/system-version.txt"
cp "$SERIAL_LOG" "$ARTIFACT_DIR/qemu-serial.log"
guest_ssh "shutdown -p now" || true
for _ in $(seq 1 30); do
    if ! kill -0 "$QEMU_PID" 2>/dev/null; then
        break
    fi
    PROCESS_STATE="$(ps -o stat= -p "$QEMU_PID" 2>/dev/null || true)"
    [[ "$PROCESS_STATE" == Z* ]] && break
    sleep 2
done
if kill -0 "$QEMU_PID" 2>/dev/null; then
    echo "Guest did not shut down after smoke checks." >&2
    exit 1
fi
wait "$QEMU_PID" || true
QEMU_PID=""

qemu-img convert -p -f qcow2 -O qcow2 "$DISK_IMAGE" "$ARTIFACT_IMAGE"
xz --threads=0 --compress --keep --force -- "$ARTIFACT_IMAGE"
rm -f "$KEY_FILE" "$KEY_FILE.pub"
printf 'Base image SHA-512: %s\n' "$BASE_SHA512" > "$ARTIFACT_DIR/build-provenance.txt"
printf 'Source image: %s\n' "$IMAGE_NAME" >> "$ARTIFACT_DIR/build-provenance.txt"
printf 'Package set: build/packages.txt\n' >> "$ARTIFACT_DIR/build-provenance.txt"
printf 'Build time UTC: %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" >> "$ARTIFACT_DIR/build-provenance.txt"
echo "Image and smoke artifacts written to $ARTIFACT_DIR"


