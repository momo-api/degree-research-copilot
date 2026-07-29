# Verified research-skill catalog

Checked: 2026-07-29. Treat upstream counts, versions, commands, and maturity labels as mutable. Recheck the linked repository before installation or update.

## Contents

1. Selection rule
2. Verified catalog
3. Installation routes
4. Comparison notes
5. Claims corrected from the legacy guide
6. Primary sources

## Selection rule

Use one general orchestrator and at most one specialist package for a task. Prefer individual or category installs from large libraries.

Why: Codex initially loads skill names and descriptions under a bounded metadata budget. The current Codex manual states that the initial list uses at most 2% of context, or 8,000 characters when context size is unknown; large sets may be shortened or omitted. This is a product fact. The recommendation to use one general plus one specialist is a lab policy derived from that fact, not an OpenAI requirement.

## Verified catalog

| Package | Best fit | Verified shape | License | Recommendation |
|---|---|---|---|---|
| ARS-Codex | General academic workflow | One Codex-native `academic-research-suite` router; current repository version observed as 0.1.22 | CC BY-NC 4.0 | Default general orchestrator for non-commercial academic use; review license for other use |
| Scientific Agent Skills | Biology, chemistry, medicine, scientific databases | 158 skills claimed by current README; supports focused installs | MIT | Install only needed skills such as `database-lookup`, `paper-lookup`, `scanpy`, or `rdkit` |
| ARIS | Autonomous AI/ML research iteration | Roughly 80 skills plus managed project installers; current README provides a Codex mirror route | MIT | Use project-scoped and selectively; best when real experiments and iteration are in scope |
| Orchestra AI Research Skills | AI research engineering | 98 skills across 23 categories claimed by current README; includes `autoresearch` | MIT | Prefer a quickstart, category, or individual selection; avoid all 98 by default |
| zLanqing academic skills | Chinese writing, Office artifacts, scientific computing | Three top-level skills | MIT, with some bundled external resources under their original licenses | Useful, but do not copy the repository's outdated Codex installation section verbatim |
| PaperSpine | Contribution, motivation, paper argument | V4 is one `paper-spine` orchestrator with 12 stages | MIT | Add only when the paper's spine is unclear; not a general literature tool |
| Nature Skills | Focused English, figures, review, references, statistics, revision | Multi-skill repository with a shared dependency; names/count and maturity labels change upstream | Apache-2.0 | List current skills, then install only the needed unit and documented shared dependency; not Nature Portfolio software |
| paper-craft-skills | Method figures, visual decks, paper explainers | Three skills: `paper-comic`, `paper-deck`, `paper-analyzer` | MIT | Communication/output layer; optional, not a core research-validity layer |
| Research-Paper-Writing-Skills | ML-style paper section writing and self-review | One `research-paper-writing` skill with section references; methodology is substantially adapted from credited public notes | MIT | Narrow writing specialist; complement rather than replace research/evidence workflows |
| PaperJury Codex | Evidence-bounded pre-submission review and minimal revision | Codex plugin/skill with review → adjudication → patch → recheck and deterministic Node guards | MIT | Use after a real draft exists; author handles missing experiments/evidence and approves material edits |

## Installation routes

Inspect third-party code and license before executing it. Ask the user before installation or update.

### ARS-Codex

Prefer the upstream Codex plugin:

```powershell
codex plugin marketplace add Imbad0202/academic-research-skills-codex --ref main
codex plugin add ars-codex@ars-codex
```

Open a new conversation and verify with `/skills`; expect one router entry, `academic-research-suite` or `ARS-Codex`, rather than separate deep-research or reviewer skills.

### Scientific Agent Skills

List first, then install a focused unit. With GitHub CLI 2.90.0 or newer:

```powershell
gh skill install K-Dense-AI/scientific-agent-skills
gh skill install K-Dense-AI/scientific-agent-skills database-lookup --agent codex
gh skill install K-Dense-AI/scientific-agent-skills scanpy --agent codex
```

Standards-based alternative:

```powershell
npx skills add K-Dense-AI/scientific-agent-skills
```

Do not install all 158 globally unless the lab has explicitly accepted the context, maintenance, dependency, and supply-chain cost.

### ARIS

Clone to a stable location and use its managed, project-scoped installer. On Windows:

```powershell
git clone https://github.com/wanshuiyin/Auto-claude-code-research-in-sleep.git "$HOME\aris_repo"
Set-Location "$HOME\aris_repo"
.\tools\install_aris.ps1 C:\path\to\your-codex-project -Platform codex
```

Use upstream selective-install controls where available. ARIS can run experiments and external review loops; inspect its requested tools, hooks, model providers, and permissions before enabling unattended execution.

### Orchestra AI Research Skills

Use the interactive installer and choose quickstart, categories, or individuals:

```powershell
npx @orchestra-research/ai-research-skills
```

For most labs, begin with `autoresearch`, one ideation or paper-writing skill, and only the engineering framework actually used by the project.

### zLanqing academic skills

The current upstream README contains placeholder repository names and legacy Codex paths. Use the built-in installer with exact subpaths, or manually copy each complete skill folder to a supported skill root.

```text
$skill-installer Install this skill from:
https://github.com/zLanqing/codex-claude-academic-skills/tree/main/research-writing-skill
```

Repeat for `office-academic-skill` or `scientific-toolkit-skill`. For manual project scope, use:

```text
<project>/.agents/skills/<skill-name>/SKILL.md
```

### PaperSpine

Use the upstream installer because V4 has a generated host-specific distribution:

```powershell
git clone https://github.com/WUBING2023/PaperSpine.git
Set-Location .\PaperSpine
.\install.ps1 -CleanLegacy
```

Use `-CleanLegacy` when migrating from a pre-V4 multi-worker installation. Inspect the script before running; it installs for multiple supported hosts and writes PaperSpine state under the user profile.

### Nature Skills

List names and install selectively:

```powershell
npx skills add Yuan1z0825/nature-skills --list
npx skills add Yuan1z0825/nature-skills --agent codex --skill nature-figure --yes --copy
```

Some skills require `nature-shared`. Example:

```powershell
npx skills add Yuan1z0825/nature-skills --global --agent codex `
  --skill nature-polishing --skill nature-shared --yes --copy
```

Do not describe this community repository as an official Nature Portfolio product.

### paper-craft-skills

```powershell
npx skills add zsyggg/paper-craft-skills
```

Use it after scientific content is stable. Generated diagrams and slide images must be labeled and checked against the paper.

### Research-Paper-Writing-Skills

Install the single skill with the built-in installer or inspect and copy its complete folder:

```text
$skill-installer Install research-paper-writing from https://github.com/Master-cai/Research-Paper-Writing-Skills/tree/main/research-paper-writing
```

Use it for a bounded section rewrite or self-review. It does not conduct the underlying literature search or experiment.

### PaperJury Codex

Prefer its published plugin marketplace route:

```powershell
codex marketplace add u7079256/paperjury-codex@v1.0
```

Then install **PaperJury Codex** in the plugin UI. Node is required; a LaTeX toolchain is optional. Its `auto` mode requires explicit authorization, and reviewer findings do not substitute for author judgment or peer review.

## Comparison notes

### ARS-Codex versus PaperSpine

- Choose ARS-Codex for broad research routing: scoping, literature, drafting, review, revision, and staged pipelines.
- Add PaperSpine only when motivation, contribution, evidence alignment, or section function is the bottleneck.
- Do not run both as peer orchestrators. Let one own the task and call the other for a bounded artifact if needed.

### ARIS versus Orchestra

- Choose ARIS for a managed, iterative research loop with experiment execution, persistent research memory, adversarial review, and paper workflows.
- Choose Orchestra when the main need is deep framework-specific AI research engineering guidance across training, evaluation, inference, RAG, MLOps, and related categories.
- Both are large. Prefer a project-scoped subset.

### Scientific Agent Skills versus zLanqing scientific-toolkit

- Choose Scientific Agent Skills for domain databases and specialized bio/chem/medical workflows.
- Choose zLanqing `scientific-toolkit-skill` for Chinese-first scientific computing, especially optics/optoelectronics and common MATLAB/Python analysis.
- Verify package versions, APIs, and database results at execution time.

### Nature Skills versus paper-craft-skills

- Choose a Nature Skill for a narrow manuscript, citation, statistics, revision, or publication-figure workflow.
- Choose paper-craft for explanatory HTML, visual decks, or method illustrations.
- Neither replaces source-level scientific verification.

## Claims corrected from the legacy guide

| Legacy claim | Verified correction |
|---|---|
| Enable `[features] skills = true` | Not present in the current Codex manual; remove it from the default setup |
| User skills live at either `.codex/skills/SKILL.md` or `.agents/skills/SKILL.md` | A skill requires its own directory. Current public Codex docs list `$HOME/.agents/skills/<name>/SKILL.md`; the bundled `$skill-installer` may install under `$CODEX_HOME/skills`, so use the installer or the documented `.agents` path rather than a bare `skills/SKILL.md` |
| Project skills go in `.codex/skills` | Current public Codex docs specify `.agents/skills` from CWD up to repository root |
| Restart is always required | Codex detects skill changes automatically; restart or open a new conversation if a change does not appear. Some third-party routers explicitly require a new conversation after install |
| Fake citations are normal | Fabricated citations are never acceptable. Unverified citations are an unresolved error state, not expected output |
| paper-craft does not advance research | This is an editorial judgment. It is better classified as an optional communication and visualization layer |
| Nature Skills is for polishing and revision only | The repository spans figures, writing, review, citations, data/statistics, reading/search, literature pipelines, logs, proposals, patents, and revision; list the current upstream skills because the inventory changes |

## Primary sources

- Codex skills: https://learn.chatgpt.com/docs/build-skills.md
- Codex `AGENTS.md`: https://learn.chatgpt.com/docs/agent-configuration/agents-md.md
- ARS-Codex: https://github.com/Imbad0202/academic-research-skills-codex
- Scientific Agent Skills: https://github.com/K-Dense-AI/scientific-agent-skills
- ARIS: https://github.com/wanshuiyin/Auto-claude-code-research-in-sleep
- Orchestra AI Research Skills: https://github.com/Orchestra-Research/AI-Research-SKILLs
- zLanqing academic skills: https://github.com/zLanqing/codex-claude-academic-skills
- PaperSpine: https://github.com/WUBING2023/PaperSpine
- Nature Skills: https://github.com/Yuan1z0825/nature-skills
- paper-craft-skills: https://github.com/zsyggg/paper-craft-skills
- Research-Paper-Writing-Skills: https://github.com/Master-cai/Research-Paper-Writing-Skills
- PaperJury Codex: https://github.com/u7079256/paperjury-codex
