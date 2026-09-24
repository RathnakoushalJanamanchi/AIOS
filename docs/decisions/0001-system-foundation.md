# ADR-0001: Use FreeBSD as the initial system foundation

- **Status:** Accepted for the v0.1 development platform
- **Date:** 2026-09-24
- **Decision owners:** Project maintainers/product owner

## Context

The engineering brief originally recommended Linux. The product owner explicitly requires a non-Linux OS. The product targets installable x86-64 PCs and needs graphics, networking, storage, security, and a QEMU-first build/test path.

## Decision

Use **FreeBSD 15.1-RELEASE amd64** as the pinned Phase 2 QEMU image/kernel/base. Develop Indian AIOS as a FreeBSD-based product layer with its own shell, services, localization, AI permissions, integrations, and release engineering. Do not call this a new kernel or a Windows clone.

The first Phase 2 VM uses an official FreeBSD 15.1 UFS cloud-init QCOW2 image verified against its published SHA-512. Before an end-user release, test and select a supported FreeBSD branch and a documented upgrade/rollback strategy. On the decision date FreeBSD 15.1-RELEASE is supported through 2027-03-31; stable/15 has an expected end date of 2029-12-31.

## Alternatives

- **Linux distribution:** better PC hardware breadth, but conflicts with the explicit non-Linux requirement.
- **Windows product layer:** broad driver/application compatibility, but depends on proprietary Windows licensing and platform control; it is not an independently developed OS.
- **New kernel:** meets a strict non-Linux request, but requires a new driver, graphics, networking, security, application, update, installer, and compatibility ecosystem. Not feasible as the first deployable PC product without significant additional resources.
- **Other BSD/new OS:** can be reconsidered if FreeBSD fails driver, desktop, licensing, or upgrade gates.

## Consequences

- The kernel is non-Linux and mature, but the product inherits FreeBSD's driver availability and upstream release cadence.
- FreeBSD's permissive base license eases redistribution; every third-party package still requires its own license and security/update review.
- No hardware compatibility beyond QEMU is implied by this decision.
- The kernel could be replaced later only through a separately reviewed architecture decision and compatibility plan.

## Sources

- [FreeBSD release and security support](https://www.freebsd.org/security/)
- [FreeBSD 15.1 release image index](https://download.freebsd.org/releases/VM-IMAGES/15.1-RELEASE/amd64/Latest/)
- [FreeBSD Handbook: graphics drivers](https://docs.freebsd.org/en/books/handbook/x11/)

