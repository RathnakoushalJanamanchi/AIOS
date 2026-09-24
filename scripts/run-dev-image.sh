#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE="${1:-$ROOT/build/artifacts/indian-aios-dev.qcow2}"
WORK_DIR="${AIOS_BUILD_DIR:-$ROOT/build/dev-image-work}"
QEMU_BIN="${QEMU_BIN:-qemu-system-x86_64}"

if [[ "$IMAGE" == *.xz ]]; then
    mkdir -p "$WORK_DIR"
    DISK="$WORK_DIR/indian-aios-dev.qcow2"
    if [[ ! -f "$DISK" || "$IMAGE" -nt "$DISK" ]]; then
        xz --decompress --stdout "$IMAGE" > "$DISK.tmp"
        mv "$DISK.tmp" "$DISK"
    fi
    IMAGE="$DISK"
fi
if [[ ! -f "$IMAGE" ]]; then
    echo "Image not found: $IMAGE" >&2
    echo "Build it with ./scripts/build-dev-image.sh or pass a QCOW2 image path." >&2
    exit 2
fi
command -v "$QEMU_BIN" >/dev/null 2>&1 || {
    echo "QEMU system emulator not found: $QEMU_BIN" >&2
    exit 2
}

QEMU_ACCEL=()
if [[ -r /dev/kvm && -w /dev/kvm ]]; then
    QEMU_ACCEL=(-accel kvm)
fi
exec "$QEMU_BIN" \
    "${QEMU_ACCEL[@]}" \
    -machine q35 -cpu max -smp "${AIOS_QEMU_CPUS:-4}" -m "${AIOS_QEMU_MEMORY:-8192}" \
    -drive "file=$IMAGE,if=virtio,format=qcow2" \
    -netdev user,id=net0 -device virtio-net-pci,netdev=net0 \
    -vga std

