# Architecture (initial proposal)

## Product boundary

Indian AIOS is a complete product: system foundation, desktop, system services, applications/integrations, localization, AI permissions, packaging, updates, installation, recovery, testing, and documentation. It is not just a desktop theme or chatbot.

## Layer model

1. **Platform foundation:** kernel or host OS, boot, drivers, graphics, audio, networking, storage, security primitives.
2. **System services:** sessions, settings, notifications, search index, software/update service, logs, device management.
3. **Desktop shell:** launcher, panel/taskbar, window management, accessibility, localization and input integration.
4. **Applications:** file management, terminal, browser, productivity apps, software catalog.
5. **AI services:** model adapter, orchestration, retrieval, tool registry, permission broker, audit/undo, user interface.
6. **Distribution:** reproducible builds, signed artifacts, installer, recovery, release channels, compatibility data.

These layers communicate through explicit APIs. AI models do not receive direct privileged access; tools request narrowly scoped capabilities from a separate permission broker.

## Kernel and OS foundation

Unresolved. See [ADR-0001](docs/decisions/0001-system-foundation.md). The project must not claim “not Linux” while shipping a Linux kernel. A Windows-based shell/product layer would depend on a proprietary Windows license and would not constitute an independently developed operating system. A new kernel would require a separate feasibility case for drivers, hardware support, security maintenance, application compatibility, and funding.

## Multilingual design

- Use Unicode end-to-end and avoid language-specific assumptions in core services.
- Keep translated strings in locale resources with stable keys and source-language context.
- Keep locale formatting, input methods, fonts, and speech/translation providers behind replaceable interfaces.
- Track quality and coverage per language; translated UI alone is not a language-support claim.
- Initial resource samples live under `localization/`.

## AI trust boundaries

- Model output is untrusted input.
- Orchestration can only call registered tools.
- Tools receive explicit, narrow capabilities and validate arguments independently.
- The permission broker gates sensitive access and operations.
- The UI shows action summaries and asks for confirmation for consequential changes.
- Audit events avoid storing secrets and expose retention controls.
- Network access and remote inference are disclosed and controlled by the user.

## Provisional technology approach

Do not lock languages or frameworks before the foundation choice. The system should use memory-safe languages for new privileged services where the selected platform and available bindings make that practical; use established native toolkits and system APIs for the desktop; define stable IPC and localization boundaries; and reuse maintained upstream software for commodity capabilities. Each dependency needs a license, security-update, and maintenance review.

## Design records

- [ADR-0001: system foundation](docs/decisions/0001-system-foundation.md)

