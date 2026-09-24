# ADR-0001: Choose the system foundation

- **Status:** Proposed; decision required
- **Date:** 2026-09-24
- **Decision owners:** Project maintainers and product owner

## Context

The engineering brief recommends the Linux kernel as a mature starting point. The product request says the OS should not be Linux-based. The product must target installable x86-64 PCs and eventually offer graphics, networking, audio, Bluetooth, USB, printing, power management, updates, recovery, security, and application support.

## Options to evaluate

### A. Linux-based distribution with an original product layer

Use a supported kernel and mature driver/system infrastructure; develop the Indian AIOS shell, language experience, AI permission architecture, services, integration, and distribution. This is the shortest path to broad PC hardware support, but it does not meet a literal non-Linux requirement.

### B. Windows-based product layer

Build an Indian AIOS desktop/app experience on top of licensed Windows. This can reuse Windows hardware and application support, but depends on Microsoft's licensing, updates, platform APIs, and product rules. It is a product layer, not an independently developed operating system or kernel.

### C. New kernel and OS

Develop or adopt a non-Linux kernel and build the driver, graphics, networking, security, application, installer, and update ecosystem. This can satisfy a strict non-Linux requirement, but the project must demonstrate a credible driver strategy, supported hardware, security maintenance capacity, and application compatibility before promising a deployable PC product.

### D. Existing non-Linux open-source OS research

Evaluate existing projects as research or potential foundations. Verify current hardware support, license compatibility, contributor capacity, security response, and feasibility of the intended desktop/app ecosystem. Do not assume a project is suitable based on its kernel alone.

## Evaluation criteria

- Meets the product owner's meaning of “not Linux.”
- Can boot and install on named x86-64 PCs with documented driver coverage.
- Supports a secure update/recovery model and long-term vulnerability response.
- Supports required applications and multilingual input/accessibility.
- Permits the intended redistribution and commercial/governance model.
- Can be built, tested, and maintained by the available team and funding.
- Has a credible QEMU-first development and automated test path.

## Decision

No selection yet. Do not implement an irreversible kernel-specific architecture before this comparison is complete. Work that remains useful across options—product requirements, localization resources, threat model, permissioned AI interfaces, release criteria, and test plans—may proceed.

## Consequences

The project cannot yet claim to be a Linux-free OS or promise a specific bootable platform. Milestone 0 must close this decision before the image-building milestone is fixed.

