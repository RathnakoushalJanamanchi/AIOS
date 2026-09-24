# Technology options to investigate

This is an investigation list, not a selected stack. Evaluate current licenses, maintenance health, security response, hardware support, APIs, and build requirements before adopting a component.

| Area | Candidate direction | Research questions |
|---|---|---|
| Kernel/OS base | Linux distribution; licensed Windows product layer; existing non-Linux OS; new kernel | Which interpretation of “not Linux” is required? Which target PCs and drivers are mandatory? Who supplies security updates? |
| Desktop | Native shell over chosen platform APIs | Toolkit accessibility, localization, windowing, theming, session security, and long-term maintenance |
| Privileged services | Rust or another memory-safe language where bindings/platform support permit; C/C++ only where necessary | ABI/API stability, IPC, service supervision, sandbox integration, auditability |
| UI/application layer | TypeScript/web UI or native toolkit depending platform | Resource use, accessibility, localization tooling, packaging, offline behavior, attack surface |
| Search | Local index first; metasearch or licensed web data later | Indic tokenization/stemming, transliteration, privacy, spam, crawling rights, operational cost |
| Browser | Maintained Chromium-based build or other supported browser engine | Build size, codecs, update cadence, sandbox, branding/trademark, API keys, security staffing |
| Office | Integrate/adapt a maintained suite first; add native AI/language workflows | DOCX/XLSX/PPTX compatibility, licensing, accessibility, fonts, macros, file safety |
| Language technology | Local models plus optional BHASHINI/other services | Per-language benchmarks, API terms, data handling, latency, availability, offline support |
| AI inference | Pluggable local and explicitly configured remote providers | Hardware classes, model licenses, acceleration APIs, private data handling, fallback behavior |
| Packaging/updates | Signed repositories and rollback-capable system updates | Atomicity, key custody, recovery, bandwidth, delta support, reproducibility |
| Installer/recovery | Platform-native installer and recovery image | Secure boot, disk encryption, dual boot, accessibility, rollback and data preservation |
| CI/test | Reproducible builds, QEMU/virtualization, hardware lab | Emulator fidelity, boot automation, language test coverage, firmware/device matrix |

## First research deliverable

Complete ADR-0001 with a sourced comparison, list of target devices, realistic build/test steps, license/provenance policy, and explicit non-goals. Avoid selecting several competing frameworks before the platform decision.

