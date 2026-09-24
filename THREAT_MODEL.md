# Initial threat model

This is a starting inventory, not a completed security assessment.

## Assets

- User documents, credentials, browsing data, and identity information.
- System integrity, boot/update keys, package metadata, and recovery path.
- AI permissions, tool requests, audit records, and model prompts/results.
- Availability and integrity of network, storage, and installed applications.

## Threat actors and failure sources

- Malicious applications, websites, documents, packages, or model prompts.
- Compromised update/build infrastructure or signing credentials.
- Remote services receiving data during optional inference or integrations.
- Accidental user actions, incorrect AI output, and hardware failures.

## Trust boundaries

- User session versus privileged system services.
- Application sandbox versus host files and devices.
- Untrusted model output versus validated tool requests.
- Local processing versus remote services.
- Build/release infrastructure versus installed system images.

## Initial mitigations to design and verify

- Capability-based access, sandboxing, explicit consent, safe defaults, and auditable actions.
- Signed artifacts, reproducible build goals, key rotation/recovery plans, and rollback.
- Per-integration data-flow disclosure and remote-processing controls.
- Fuzzing/validation for parsers and tool arguments; security regression testing.

## Open questions

- Kernel/host threat model and secure boot chain depend on ADR-0001.
- Define supported hardware security features and minimum requirements.
- Define incident response, vulnerability disclosure, and update service ownership.
- Define log retention and user-accessible data deletion controls.

