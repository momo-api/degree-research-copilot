# Repository instructions

- The distributable plugin lives under `plugins/lab-research-kit/`.
- Keep `.agents/plugins/marketplace.json` and `.codex-plugin/plugin.json` valid and version-aligned.
- Run `scripts/test-repository.ps1` after any Plugin, Skill, reference or script change.
- Use `apply_patch` for hand-authored edits and preserve unrelated user changes.
- Never commit real research workspaces, student information, unpublished data, credentials or patient material.
- Keep the core `SKILL.md` concise; place detailed methods in references and deterministic behavior in scripts.
- Do not claim that deterministic tests establish scientific correctness or guarantee graduation/publication.
- Update `CHANGELOG.md` for user-visible changes.
