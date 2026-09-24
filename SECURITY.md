# Security policy (initial)

Security is a release requirement. This project is at planning stage; no OS image or security guarantee is currently provided.

## Initial commitments

- Keep model inference, orchestration, system tools, and permission decisions separate.
- Do not run an AI assistant as unrestricted administrator/root.
- Enforce least privilege, argument validation, and authorization at the tool boundary.
- Require explicit approval for destructive, privileged, externally visible, or difficult-to-reverse actions.
- Use signed update artifacts and document key custody, recovery, and rollback before a release.
- Minimize sensitive logging; document collection, retention, and user controls.
- Track third-party dependencies, licenses, advisories, and update ownership.

## Reporting a vulnerability

Until a private security contact is configured, do not publish details of an unpatched vulnerability in an issue. The maintainers must establish a monitored private reporting channel before distributing public builds.

## Release claims

Do not claim a feature is secure based only on design documentation. Claims require implementation review and relevant tests on the supported release configuration.

