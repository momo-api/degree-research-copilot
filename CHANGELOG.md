# Changelog

All notable changes to this project are documented here. The project follows semantic versioning.

## [2.2.0] - 2026-07-29

### Added

- Canonical project state at `research/project.json`.
- Project status reader and generated `status.md` view.
- Atomic project profile/workflow update and Track migration.
- Institution milestones, weekly progress, meeting and AI-use ledgers.
- Stage validator for intake through defense.
- Chinese degree-program gates covering task book/training plan, proposal, midterm, pre-defense, external review, submission, defense and archive.
- GitHub Marketplace structure, Codex App installation prompt and Windows CI.

### Changed

- Expanded adaptive initialization counts to 19/22/26/28 for representative profiles.
- Existing project metadata is restored from canonical state instead of chat history or generated headers.
- Conflicting reinitialization is rejected with migration guidance.
- Old Track files are retained as historical records.
- External research-skill catalog now covers ten optional packages without bundling their code.

### Fixed

- Stage validation no longer counts template Degree/Track/Initialized metadata as substantive intake content.
- Profile-header synchronization and tests now preserve and accept Windows CRLF line endings.

### Validation

- 25/25 deterministic tests pass in the source tree and extracted release archive.
- Skill and Plugin validators pass.

## [2.1.0] - 2026-07-29

- Added degree/Track adaptive project templates and 13 deterministic tests.
- Added experimental design, proposal, writing/review and integrity references.

[2.2.0]: https://github.com/momo-api/degree-research-copilot/releases/tag/v2.2.0
[2.1.0]: https://github.com/momo-api/degree-research-copilot/releases/tag/v2.1.0
