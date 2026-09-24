# Indian AIOS

Indian AIOS is a proposed Indian-language-first desktop product for Indian PC users. It aims to combine a familiar desktop, local-first search, permissioned AI assistance, productivity apps, accessible language support, and clear software/data provenance.

**Current foundation decision:** FreeBSD 15.1-RELEASE for the Phase 2 x86-64/QEMU development image. Indian AIOS is non-Linux; this is a FreeBSD-based product layer, not a new kernel or Windows clone.

**Current status:** Phase 1 product decisions are recorded. Phase 2 has a QEMU build-and-smoke workflow; its first hosted run is the acceptance gate. It is not yet a physical-PC installer or end-user release.

## Start here

- [Complete product overview](docs/product-overview.md)
- [Phase 1 feasibility and product decisions](docs/PHASE-1-DECISIONS.md)
- [Phase 2 development image guide](docs/PHASE-2-DEV-IMAGE.md)
- [Architecture](ARCHITECTURE.md)
- [Roadmap](ROADMAP.md)
- [Security policy](SECURITY.md)
- [Threat model](THREAT_MODEL.md)

## Build and run the development VM

On Linux or WSL2 with QEMU system emulation, cloud-image-utils, xz, curl, and OpenSSH installed:

```sh
bash scripts/build-dev-image.sh
bash scripts/run-dev-image.sh
```

The build verifies the official FreeBSD base image SHA-512, provisions XFCE in QEMU, runs guest smoke checks, and emits a compressed QCOW2 image plus build diagnostics. GitHub Actions builds the same image and makes it available as a seven-day workflow artifact.

This is a development VM with console auto-login and passwordless sudo. Do not use it for sensitive data or as a production install.

## Multilingual seed

The starter UI catalogs cover English (India), Hindi, Tamil, and Telugu. They are not complete translations. Validate keys/placeholders with:

```sh
python scripts/check_locales.py
python -m unittest discover -s tests -p 'test_*.py'
```

## Ownership and licensing

Project-authored source is licensed under Apache-2.0. FreeBSD and bundled third-party software retain their own licenses, copyrights, and notices. The project will publish component provenance, update responsibility, and data flows; operational ownership and release-key custody must be established before public end-user distribution.


