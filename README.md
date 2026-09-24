# Indian AIOS

Indian AIOS is a proposed, multilingual desktop operating system for Indian users. The project aims to make a secure, accessible PC experience with Indian-language input and services, user-controlled AI, useful productivity workflows, and transparent software ownership.

This repository is at the **planning and feasibility stage**. It does not yet contain an operating system, installer, browser, office suite, or working AI agent. No feature should be described as implemented until it has been built and verified.

## Product direction

- Start with a reproducible developer platform and QEMU-based validation.
- Treat Indian languages, accessibility, privacy, and supported hardware as product foundations.
- Build the distinctive desktop, permissioned AI layer, localization experience, and integration APIs.
- Adapt or integrate mature components when that is safer and more maintainable than recreating them.
- Publish provenance, licenses, update ownership, and data flows for included components.

## Important open decision: system foundation

The original engineering brief names Linux as the initial kernel foundation. The product request also says Indian AIOS should not be based on Linux. These requirements conflict. The kernel and driver strategy is therefore an open feasibility decision; this repository does not claim a non-Linux foundation or quietly select Linux.

See [the architecture](ARCHITECTURE.md), [the roadmap](ROADMAP.md), and [ADR-0001](docs/decisions/0001-system-foundation.md). The first development work is a comparative feasibility study covering a mature Linux distribution, a Windows-based product layer, and a new-kernel path. A new kernel is not assumed to be practical for the first deployable release.

## Languages and technology

The product targets multilingual Indian-language support through Unicode, locale-aware formatting, keyboard and input-method integration, tested fonts, and localized UI resources. Initial sample translations are English, Hindi, Tamil, and Telugu. These samples are not a claim of complete language coverage.

Technology choices for the desktop, system services, AI runtime, browser, office applications, packaging, and installer remain provisional until the foundation study is complete. The project will prefer stable interfaces and documented upstream components over a premature, all-new stack.

## Repository map

- `ARCHITECTURE.md` — product boundaries and open architecture decisions
- `ROADMAP.md` — staged milestones and acceptance criteria
- `SECURITY.md` — initial security commitments
- `THREAT_MODEL.md` — initial assets, actors, and boundaries
- `docs/decisions/` — architecture decision records
- `localization/` — locale metadata and starter UI strings
- `research/` — comparative technology evaluation

## Current status

**Milestone 0: feasibility and project foundation.** No bootable image or OS implementation exists yet. The next gate is a reviewed system-foundation decision with evidence for kernel, driver, licensing, update, and test strategy.

