# Technology decisions and continuing research

Phase 1 decisions are captured in [PHASE-1-DECISIONS.md](../docs/PHASE-1-DECISIONS.md). This file tracks selected v0.1 directions and areas still needing validation.

| Area | v0.1 direction | What remains to prove |
|---|---|---|
| Kernel/OS base | FreeBSD 15.1 amd64, non-Linux | Supported branch migration, installer/recovery, physical-device drivers, secure updates |
| Desktop | XFCE for development image; original AIOS shell later | Visual design, input/accessibility APIs, shell integration |
| Privileged system services | Rust where FreeBSD bindings mature | IPC, service supervision, sandbox/capability implementation |
| UI and browser integrations | TypeScript/WebExtensions | Accessibility, offline behavior, app isolation, browser update channel |
| Developer and AI tooling | Python for localization/model experimentation | Reproducible dependency lock and model evaluation |
| Local search | SQLite FTS5 plus replaceable tokenizer/indexer interface | Indic-script normalization, transliteration, ranking, private index policy |
| Web search | Optional SearXNG or licensed-provider connector | Search provider policy, relevance, privacy, availability, operating cost |
| Browser | Upstream FreeBSD Chromium package, no Google Chrome branding | Security-update SLAs, codecs, sandbox verification, exact trademark and distribution requirements |
| Office | Upstream LibreOffice integration | DOCX/XLSX/PPTX compatibility, language/fonts, macro/document threat model |
| AI runtime | Provider-neutral API; optional llama.cpp local inference | FreeBSD performance/acceleration, model licenses, Indic benchmarks |
| Packages and updates | FreeBSD pkg for development; signed AIOS layer to design | Immutable repository snapshots, signing keys, rollback, SBOM, CVE response |
| Image/CI | Official checksum-pinned QCOW2 + QEMU + GitHub Actions | Package lock, deterministic artifact, GUI visual review |

## Dependency/license policy

- Project-authored code uses Apache-2.0.
- Preserve upstream licenses, notices, trademarks, and source attribution.
- Record exact component version, upstream URL, license ID, source/build input, security owner, and update cadence in an SBOM for each release.
- Do not embed model weights, fonts, codecs, or firmware until redistribution terms are explicitly reviewed.

