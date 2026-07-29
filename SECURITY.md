# Security Policy

## Supported version

Only the latest `2.x` release receives security and data-safety fixes.

## Report privately

Do not open a public issue for vulnerabilities involving credential exposure, path traversal, unsafe file mutation, private research data, plugin installation or supply-chain risk.

Because this repository is currently private, open a private repository Issue visible only to collaborators, or contact the maintainer through the laboratory's established private channel. If GitHub private vulnerability reporting is enabled after a future public release, prefer **Security → Report a vulnerability**. Include:

- affected version and operating system;
- exact command or prompt;
- minimal reproduction using synthetic data;
- observed and expected behavior;
- whether credentials, unpublished research or personal data may be exposed.

Do not include real student, patient, participant or unpublished research data in the report.

## Scope

Security issues include unsafe project-path handling, unexpected overwrite/deletion, metadata injection, plugin/marketplace source confusion, secret leakage and instructions that bypass ethics, biosafety or institutional authorization.

Scientific disagreement or model-quality variation is not automatically a software vulnerability, but fabricated evidence or unsafe research claims should still be reported as a quality defect.
