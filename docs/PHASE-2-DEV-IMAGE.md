# Phase 2 — QEMU development image

## What this image is

A FreeBSD 15.1 amd64 UFS QCOW2 developer VM provisioned with XFCE, Xorg, LightDM, an XFCE terminal/settings, UFS storage, QEMU user-mode networking, and syslog. The image starts an XFCE session automatically for a quick development preview. It is a **development image**, not an installer or a secure general-purpose release. It contains a password-locked local account configured for console auto-login and passwordless sudo, so do not use it with personal files or expose its SSH service to a network.

It uses upstream FreeBSD and packages with an AIOS development setup; it is not yet a custom AIOS shell or polished end-user desktop.

## Build and run

Build on Linux or WSL2 with QEMU system emulation, `qemu-img`, `cloud-image-utils`, `xz`, `curl`, `ssh`, and `ssh-keygen` installed:

```sh
./scripts/build-dev-image.sh
./scripts/run-dev-image.sh
```

The GitHub Actions workflow builds the same image and publishes a seven-day downloadable workflow artifact named `indian-aios-dev-image`. Download and extract that artifact to run it locally.

## Build inputs and repeatability

- Upstream base: FreeBSD 15.1-RELEASE amd64 UFS BASIC-CLOUDINIT QCOW2.
- Verify the compressed upstream image against its published SHA-512 checksum before use.
- Package set is explicitly listed in `build/packages.txt`.
- CI exports a full resolved package manifest, serial boot log, and compressed QCOW2.
- A QEMU smoke script checks the running desktop, X server, terminal/settings, storage, networking, and system logging.

The upstream kernel image is checksum-pinned. FreeBSD's binary package repository is updated over time, so the result is **repeatable from pinned base + declared package names, not yet bit-for-bit reproducible**. The package manifest records what a given build resolved. A frozen package repository or reproducible ports build is a prerequisite before calling the release image fully reproducible.

## Smoke acceptance criteria

1. QEMU reaches a guest SSH service.
2. Cloud-init installs the declared package set without an error.
3. LightDM, Xorg, and the XFCE session are running.
4. XFCE terminal and settings commands are installed.
5. The guest can write to its home directory and root filesystem.
6. QEMU user-mode network interface has a DHCP address.
7. A smoke marker reaches `/var/log/messages`.
8. Workflow artifacts include image, package manifest, and boot log.

## Manual controls and recovery

- Close the QEMU window to stop the VM; its disk persists.
- The VM auto-logs in as `aios` on its local console.
- Open XFCE Terminal and run `sudo passwd aios` to set a local password.
- Remote SSH is intended only for the isolated CI build process. Configure your own key and firewall before enabling it for local use.
- Remove the VM disk to reset the dev environment. It is not an installer for a physical PC.

## Known limitations

- QEMU verifies emulated devices, not real hardware.
- Package repository contents may change; package versions are recorded but not locked to a permanent mirror snapshot.
- The auto-login/sudo profile is intentionally unsuitable for production.
- No custom AIOS shell, search service, AI agent, office suite, browser branding, installer, recovery image, or update channel is included.
- QEMU's headless CI run verifies that a graphical session is running; it does not replace visual review on a desktop display.

