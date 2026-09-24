# Architecture

## Current platform decision

Phase 2 uses the FreeBSD 15.1-RELEASE amd64 kernel/base system. This satisfies the product owner's non-Linux requirement while providing a mature x86-64 OS and official QEMU QCOW2 base image. This is a FreeBSD-based product layer, not a new kernel. The current release is a development baseline; a supported branch and upgrade path must be verified before end-user release.

## Layer model

1. **Platform foundation:** FreeBSD kernel/base, boot, drivers, graphics, audio, networking, storage, security primitives.
2. **System services:** sessions, settings, notifications, local search, application/update services, logs, device management.
3. **Desktop shell:** Indian AIOS launcher, panel/taskbar, window management, accessibility, localization/input.
4. **Applications:** file manager, terminal, settings, Chromium-based browser integration, LibreOffice, software catalog.
5. **AI services:** provider adapters, orchestration, retrieval, tools, permission broker, audit/undo, UI.
6. **Distribution:** pinned/reproducible builds, signed artifacts, installer, recovery, release channels, compatibility data.

Layers communicate through versioned APIs. AI models do not receive direct privileged access; tools request narrow capabilities from a separate permission broker.

## Phase 2 development platform

The first QEMU image uses FreeBSD 15.1 UFS, XFCE/Xorg, LightDM, terminal/settings, QEMU virtio storage/network, syslog, and an isolated cloud-init provisioning step. CI validates the image over a host-forwarded SSH port, then stores the resolved package list and serial diagnostics with the bootable artifact.

The image uses an upstream desktop environment as a temporary development shell. The AIOS visual shell is later project work. Phase 2 is a VM development image, not a physical installer.

## Multilingual design

- Unicode end-to-end; core services do not hard-code language-specific behavior.
- Translation resources use stable keys and source-language context.
- Locale formatting, input methods, fonts, and speech/translation models sit behind replaceable interfaces.
- Track UI, keyboard, font shaping, search, speech, OCR, and translation quality separately by language.
- Initial sample resources: en-IN, hi-IN, ta-IN, te-IN.

## AI trust boundaries

- Model output is untrusted.
- Orchestration calls only registered tools.
- Tools validate arguments and permissions independently.
- A permission broker gates sensitive file/system access and external actions.
- The UI summarizes operations and confirms destructive, privileged, or externally visible changes.
- Audit events avoid secrets and expose retention controls.
- Remote inference is disclosed and user-controlled.

## Provisional implementation languages

Rust for new privileged services where the selected platform APIs support it; TypeScript for UI and WebExtension surfaces; Python for language/model experiments and developer tools; shell for build/CI. C/C++ remains allowed for upstream APIs/engines. IPC schemas remain language-neutral.

## Build-versus-adapt

- XFCE is adapted only as the v0.1 engineering shell; develop the AIOS shell separately.
- Chromium and LibreOffice are upstream integrations, not project-owned forks.
- Local search is a new AIOS service using SQLite FTS5 behind a tokenizer abstraction; web metasearch is optional and external.
- AI model runtime is pluggable; policy, tools, and permission broker are project-owned.

See [Phase 1 decisions](docs/PHASE-1-DECISIONS.md), [Phase 2 image guide](docs/PHASE-2-DEV-IMAGE.md), and [ADR-0001](docs/decisions/0001-system-foundation.md).

