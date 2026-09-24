# Roadmap

Status labels refer to implementation and evidence, not aspirations. Phase acceptance is complete only when its stated criteria pass and are recorded.

## Phase 1 — feasibility and product decisions

**Status: decisions recorded.**

- [x] Product definition and measurable ownership promise.
- [x] Target user groups.
- [x] Non-Linux kernel direction: FreeBSD 15.1 amd64 for the Phase 2 baseline.
- [x] Project license/provenance policy.
- [x] VM and first real-PC evaluation targets.
- [x] Initial UI language set: en-IN, hi-IN, ta-IN, te-IN.
- [x] Build/adapt/integrate decisions for desktop, browser, local/web search, AI, and office.
- [x] Complete OS concept overview and system architecture sketch.

Decision record: [Phase 1 decisions](docs/PHASE-1-DECISIONS.md).

## Phase 2 — reproducible development platform

**Status: implementation and hosted QEMU acceptance in progress.**

- [x] Pin official FreeBSD 15.1 VM image by SHA-512.
- [x] Declare desktop package set and automated provisioning.
- [x] Add QEMU build, launch, and guest smoke-check scripts.
- [x] Add CI to build/boot the image and publish diagnostics/artifact.
- [ ] Hosted QEMU workflow succeeds and uploads the image.
- [ ] Review visual desktop output on a graphical host.
- [ ] Lock exact third-party package inputs or document the remaining reproducibility limit before calling the build fully reproducible.

Acceptance requires QEMU boot; graphical login/session; terminal, settings, storage, network, logging; smoke checks; and downloadable image/provenance. See [Phase 2 image guide](docs/PHASE-2-DEV-IMAGE.md).

## Phase 3 — AIOS desktop shell

- [ ] Design tokens, shell mockups, accessibility and localization foundations.
- [ ] Original launcher/taskbar, window/session integrations, system search UI.
- [ ] File manager and coherent system settings.
- [ ] User accounts, notifications, clipboard, screenshots, and diagnostics.

## Phase 4 — Indian-language platform

- [ ] Validate en-IN, hi-IN, ta-IN, te-IN UI, keyboard layouts, fonts, locale formats.
- [ ] Define add-language review, terminology, quality and accessibility process.
- [ ] Benchmark Indic search, transliteration, OCR, speech and translation separately.

## Phase 5 — search, AI, and applications

- [ ] SQLite FTS5 local search with privacy boundaries and Indic tokenization.
- [ ] Model-provider adapters and permission broker; local/remote inference policies.
- [ ] Chromium-based browser integration and security update pipeline.
- [ ] LibreOffice integration, file-format acceptance matrix, language templates.
- [ ] Signed app catalog, permissions, updates, rollback, SBOM and vulnerability response.

## Phase 6 — product hardening and releases

- [ ] Physical PC test matrix for graphics, Wi-Fi, audio, Bluetooth, USB, power, printers.
- [ ] Signed installer, disk encryption, recovery media, tested upgrade/rollback.
- [ ] Accessibility, performance, security, localization, and application compatibility gates.
- [ ] Development, beta, release candidate, and stable channels with support policy.

## Risks and open work

- Current FreeBSD binary package repositories move over time; an immutable package snapshot or pinned ports build is needed for bit-for-bit reproducibility.
- FreeBSD graphics/Wi-Fi coverage differs by device. No universal hardware support claim.
- FreeBSD 15.1-RELEASE security support ends 2027-03-31; release engineering must test upgrades onto a supported branch well before any product release.
- Browser engine, office suite, and AI model are integrated upstream components, not original project products.
- Release-key jurisdiction, legal entity, incident response, public vulnerability contact, and update service need operational owners.

