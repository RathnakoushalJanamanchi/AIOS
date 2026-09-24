# Phase 1 — feasibility and product decisions

**Status:** Decisions recorded for the v0.1 development platform. Revisit release-specific choices before a public end-user release.

## Product and ownership promise

Indian AIOS is an independently governed Indian desktop product built on a documented mix of project-developed software and upstream components. “Indian-owned” means the project maintainers control the product roadmap, source repository, release process, desktop design, localization resources, AI policy, and (before public releases) signing keys and update infrastructure through a disclosed operating entity. It does **not** mean every kernel, driver, browser engine, model, font, or office suite is written in India or owned by this project.

The product will publish component provenance, licenses, security-update responsibility, and data flows. Core desktop use must not require a vendor account or send documents to a cloud service. Remote AI and optional government-service connectors require separate, informed user opt-in. Signing-key custody and update-service jurisdiction are release gates, not claims already satisfied by this source repository.

## First target users

1. Students and households using an affordable shared or personal PC.
2. Small businesses and independent professionals who need document, spreadsheet, presentation, web, and file workflows.
3. Indian-language-first users who need typing, search, and understandable system controls.
4. Developers and education labs who need a documented, testable desktop environment.

Public-service kiosks and managed enterprise deployments are later target segments because they need separate administration, identity, accessibility, and support requirements.

## Kernel and system foundation — selected

**Use FreeBSD 15.1-RELEASE amd64 as the Phase 2 QEMU baseline.** Indian AIOS is therefore non-Linux. Develop the AIOS desktop and services as a FreeBSD-based distribution/product layer; do not describe it as a new kernel or as Windows.

FreeBSD 15.1 is the current production release on the decision date (2026-09-24), with security support scheduled through 2027-03-31. FreeBSD 15-STABLE has an expected support end date of 2029-12-31. The development image pins the 15.1 release VM image and checksum; before an end-user release, the project must select and test a maintained branch and define the upgrade path.

The choice gives us an established x86-64 kernel, base system, package infrastructure, and QEMU image path without adopting Linux. It carries a real hardware-compatibility trade-off: GPU and Wi-Fi coverage must be tested by device, and Linux-only applications are not assumed to work. Initial validation is QEMU only; no laptop compatibility is implied.

## Licensing and project ownership

- Original Indian AIOS source in this repository: **Apache-2.0**. The repository license applies only to project-authored material and does not relicense upstream components.
- FreeBSD base/kernel: retain the applicable BSD-2-Clause and per-file notices.
- Third-party applications, fonts, firmware, models, codecs, and language data: preserve their individual licenses and attribution; maintain an SPDX inventory/SBOM before image releases.
- Do not bundle a component whose license or redistribution rights are unclear.
- No CLA or legal entity is assumed. A maintainer must approve the release governance and trademark policy before a public branded installer is distributed.

See the repository [LICENSE](../LICENSE).

## Initial hardware target

**Development VM:** amd64 QEMU, 4 vCPUs, 4 GiB RAM, 20 GiB or larger disk, emulated VGA, virtio network, and virtio block storage. CI checks use SSH plus guest-side smoke checks.

**First real-PC evaluation target (not yet certified):** UEFI x86-64 PC, at least four CPU threads, 8 GiB RAM, 128 GiB SSD, 1366×768 display, wired Ethernet, and an integrated Intel or AMD GPU. Test Wi-Fi, suspend/resume, audio, Bluetooth, USB, printing, and external displays on named models before adding them to the supported list. Local model inference should target 16 GiB RAM or more and remains optional.

## First language set

- UI and developer documentation default: English (India), `en-IN`.
- Initial translated UI and locale/input evaluation: Hindi `hi-IN`, Tamil `ta-IN`, and Telugu `te-IN`.
- All UI uses Unicode, stable translation keys, and a localization validator. The current catalogs are short starter resources, not complete translations and not proof of keyboard, font, speech, OCR, or input-method quality.
- Add later languages through contributor-reviewed catalogs and a measured input/font/rendering test plan; do not hard-code a closed language list in system services.

## Build-versus-adapt decisions

| Capability | v0.1 decision | Project-owned work |
|---|---|---|
| Desktop | Adapt XFCE as a development shell; build the Indian AIOS shell/design as a later milestone. | Design system, launcher/search integration, settings and AIOS services. |
| Browser | Use the FreeBSD Chromium package as an upstream browser in early builds. Do not fork the engine or use Google Chrome branding. | Later add an AIOS WebExtension/integration and independent product UI only after update, trademark, codec, and licensing review. Chromium security updates remain release-blocking. |
| Search | Build local-first search for apps, files, settings, and permitted document text using SQLite FTS5 behind a tokenizer/indexer interface. | Permissions, indexing policy, Indian-script tokenization/normalization, ranking, UI, and local data controls. |
| Web search | Start with an optional metasearch connector such as SearXNG or a licensed provider. Do not claim to own a global web index. | India-first ranking/content corpus only if crawl rights, data quality, abuse response, and operating cost are funded. |
| AI | Build provider-neutral orchestration, tool APIs, capability permissions, previews, audit, and undo. Evaluate llama.cpp for optional local inference; remote inference is opt-in. | Permission broker, adapters, multilingual UX/evaluation, safety tests, and settings. No model or provider is selected as a mandatory default. |
| Office | Integrate unmodified LibreOffice packages for Writer, Calc, and Impress in the product roadmap; do not recreate an office suite in v0.1. | Indian-language templates, fonts/input tests, permissioned AI actions, and compatibility acceptance tests. |

The FreeBSD Handbook documents XFCE, Chromium, and LibreOffice packages. Their presence makes these realistic integration candidates, not features already installed in the Phase 2 image.

## Implementation languages

Use Rust for new privileged daemons and permission-sensitive services where mature FreeBSD bindings support the required API; TypeScript for desktop UI/web-extension surfaces; Python for language/model experiments, data tooling, and tests; and POSIX shell for image/build automation. Use C/C++ only where an upstream system API or engine requires it. Keep IPC schemas language-neutral and versioned. This is a provisional engineering stack, not a claim that any application is implemented.

## Key risks and exit gates

- Prove GUI boot and input in QEMU, then test named physical machines before claiming PC support.
- Pin the base image by cryptographic checksum. Record package versions and build provenance; current FreeBSD package repositories are mutable, so a bit-for-bit package lock is still a release engineering task.
- Test Chromium update cadence and package availability on every supported FreeBSD branch.
- Benchmark office file compatibility and Indian-script rendering rather than relying on package availability.
- Establish release-key custody, SBOM generation, vulnerability response, and rollback before distributing an end-user image.

## Research sources

- [FreeBSD releases](https://www.freebsd.org/releases/) and [security support dates](https://www.freebsd.org/security/)
- [FreeBSD Handbook: desktop environments and applications](https://docs.freebsd.org/en/books/handbook/desktop/)
- [FreeBSD Handbook: X11 graphics drivers](https://docs.freebsd.org/en/books/handbook/x11/)
- [FreeBSD license policy](https://docs.freebsd.org/en/articles/license-guide/)
- [Official FreeBSD 15.1 VM-image index and checksums](https://download.freebsd.org/releases/VM-IMAGES/15.1-RELEASE/amd64/Latest/)
- [FreeBSD Handbook: QEMU and virtualization](https://docs.freebsd.org/en/books/handbook/virtualization/)
- [MeitY BHASHINI overview](https://www.meity.gov.in/national-language-translation-mission)

