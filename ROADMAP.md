# Roadmap

Status labels describe verified repository work, not aspirations. Nothing in this roadmap is complete until its acceptance criteria are met and evidence is recorded.

## Milestone 0 — product and foundation feasibility (current)

- [x] Record the product goal and expose the Linux versus non-Linux conflict.
- [x] Establish a multilingual localization seed and initial security boundaries.
- [ ] Compare Linux-based, Windows-based, and new-kernel approaches for the stated requirements.
- [ ] Decide target licensing and what “Indian-owned” means operationally.
- [ ] Select initial hardware targets and a QEMU/VM strategy.
- [ ] Record the decision and revise milestone 1 based on it.

**Exit criteria:** a documented, evidence-backed architecture decision; a realistic initial hardware list; a license/provenance policy; and an agreed development platform.

## Milestone 1 — reproducible development platform

- [ ] Build a reproducible developer image using the selected foundation.
- [ ] Boot in the selected emulator and collect machine-readable logs.
- [ ] Provide a graphical desktop, terminal, storage, networking, and basic settings.
- [ ] Add automated boot and smoke checks.
- [ ] Document setup, build dependencies, debugging, and known limits.

**Exit criteria:** a new developer can follow documented steps to build and boot the image, and smoke checks report results without claiming unsupported hardware coverage.

## Milestone 2 — usable desktop shell

- [ ] Login/session lifecycle, launcher, taskbar/panel, windows, notifications.
- [ ] File manager, settings, display/audio/network/power controls.
- [ ] Accessibility baseline and localization framework integration.

## Milestone 3 — Indian-language foundations

- [ ] Select initial release languages using user research and quality gates.
- [ ] Keyboard/input methods, fonts, locale formats, UI translation workflow.
- [ ] Measure search, OCR, speech, translation, and transliteration quality by language.
- [ ] Evaluate BHASHINI and other model/service providers for terms, privacy, quality, and offline operation.

## Milestone 4 — AI and system search

- [ ] Unified local search for apps, files, settings, and permitted documents.
- [ ] Model-provider interface separating inference, orchestration, tools, and UI.
- [ ] Capability-based permissions, action previews, audit trail, undo where possible.
- [ ] Local inference where supported and remote inference only with clear user choice.

## Milestone 5 — applications and ecosystem

- [ ] Decide browser strategy and establish security-update ownership.
- [ ] Decide office productivity strategy and test common document interoperability.
- [ ] App catalog, signed metadata, permission presentation, install/update/removal.
- [ ] Developer documentation and optional public-service integrations.

## Milestone 6 — hardware trials and releases

- [ ] Test on named, real x86-64 PC models; publish results and known issues.
- [ ] Installer, recovery media, update rollback, release signing and recovery drills.
- [ ] Development, beta, release-candidate, and stable channels with release criteria.

## Risks and unresolved work

- Kernel and driver strategy is unresolved and conflicts with the original brief.
- “Indian-owned” needs measurable governance, key custody, data handling, and provenance criteria.
- A new kernel, full web search index, browser engine, and office suite are each major independent programs.
- Hardware support, language quality, performance, and update reliability require measured tests; no results are claimed yet.

