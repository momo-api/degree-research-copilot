# Graduate research lifecycle

Use this reference to start, resume, or govern a master's or doctoral research project.

## Contents

1. Intake contract
2. Stage transitions
3. Workspace schema
4. Topic-selection rubric
5. Progress and recovery rules
6. Degree-program milestones and profile migration

## 1. Intake contract

Collect only what changes the next decision:

| Field | Examples |
|---|---|
| Researcher | degree, year, discipline, prior methods |
| Institution | proposal/thesis template, required headings, ethics and AI policies |
| Direction | broad topic, candidate mechanism, population/system, intended contribution |
| Constraints | deadline, budget, equipment, samples, compute, staff, access, language |
| Existing assets | papers, notes, protocols, pilot data, code, drafts, approvals |
| Deliverable | supervisor memo, proposal, protocol, thesis, paper, slides, defense |
| Success criteria | answerable RQ, pilot threshold, venue requirements, graduation requirement |
| Exclusions | prohibited data, unavailable techniques, safety limits, non-goals |

Do not demand every field before starting. Mark missing decision-critical inputs as `unresolved` and perform the smallest useful safe step.

## 2. Stage transitions

### Intake to topic

Require a bounded domain, practical constraints, and a decision deadline. Create a research brief before generating titles.

### Topic to proposal

Require:

- one primary research question and optional backup;
- a falsifiable hypothesis or clearly defined exploratory objective;
- a search-bounded novelty statement, not a claim of absolute novelty;
- feasibility under time, sample, equipment, compute, budget, and skill constraints;
- a minimal discriminating pilot and stop/pivot criteria.

### Proposal to experiment

Require a trace from each objective to a method, endpoint, analysis, risk, and expected interpretation. Identify required ethics, animal, biosafety, chemical, clinical, data, and facility approvals.

### Experiment to execution

Freeze the design version and statistical analysis plan for confirmatory work. Generate randomization or run order only after the experimental unit and blocking variables are correct. Preserve an amendment path.

### Execution to analysis

Require raw-data location, data dictionary, provenance, exclusion/deviation log, and a reproducible analysis entry point. Do not overwrite raw data.

### Analysis to writing

Require claim-evidence mapping. Separate measured results, statistical estimates, interpretation, mechanism speculation, and future work.

### Writing to review/defense

Require a stable draft, target rubric or venue, citation audit status, and a list of known limitations. Reviews must point to locators and actionable resolutions.

## 3. Workspace schema

The initializer creates:

```text
research/
├── project.json
├── 00-admin/
│   ├── research-brief.md
│   ├── decision-log.md
│   ├── status.md
│   ├── milestones.csv
│   ├── weekly-log.md
│   ├── meetings.md
│   └── ai-use-log.csv
├── 01-topic/
│   ├── topic-candidates.md
│   └── novelty-audit.md
├── 02-evidence/
│   └── evidence-matrix.csv
├── 03-proposal/
│   ├── proposal-outline.md
│   └── technical-route.md
├── 04-experiments/
│   ├── design-brief.md
│   ├── factors-and-controls.csv
│   ├── randomization.csv
│   ├── statistical-analysis-plan.md
│   └── experiment-log.md
├── 05-analysis/
│   └── analysis-log.md
├── 06-manuscript/
│   ├── claim-evidence-map.md
│   ├── paper-outline.md
│   └── manuscript.md
├── 07-review/
│   ├── review-matrix.csv
│   └── rebuttal.md
└── 08-defense/
    ├── defense-outline.md
    └── questions.md
```

The initializer creates a track-specific subset rather than this entire tree. A literature-only bachelor's project receives 19 core state/administration/research files and no experiment directory. Empirical, wet-lab, and computational tracks add six design/execution/analysis files. Engineering and design tracks add three implementation/evaluation files. Master's and doctoral projects add a rebuttal ledger; doctoral projects add research-program and work-package ledgers. Store large PDFs, raw data, images, code, and instrument files in project-specific source directories rather than these ledgers.

`research/project.json` is the canonical source for project ID, degree, institution, expected graduation, title, discipline, track, stage, work mode, health, blocker, and next gate. Generated Markdown headers and `status.md` are views, not competing sources. Resume a project with `research-status.ps1`; change profile/workflow values with `update-research-project.ps1`.

## 4. Topic-selection rubric

Score candidates only after documenting evidence and assumptions. Use a 1–5 scale with explicit reasons:

| Dimension | Question |
|---|---|
| Importance | Would answering it change understanding, practice, method, or decision? |
| Novelty | What search-bounded gap remains after checking the nearest work? |
| Falsifiability | What result would weaken or reject the hypothesis? |
| Feasibility | Can the team obtain samples/data, equipment, skills, compute, time, and approvals? |
| Identifiability | Can the design distinguish the proposed explanation from alternatives? |
| Evidence readiness | Are definitions, baselines, measurements, and key sources available? |
| Risk | What is the probability and cost of technical, ethical, recruitment, or supply failure? |
| Thesis value | Is there a coherent contribution even if the primary hypothesis is not supported? |

Do not total scores mechanically when one non-compensable constraint fails. Ethics, safety, inaccessible samples, impossible power, or unavailable equipment can veto a candidate.

## 5. Progress and recovery rules

- End each session by updating the current artifact, unresolved list, and next gate.
- Record scope and endpoint changes in `decision-log.md` before re-analysis.
- Maintain a main route and a cheaper fallback; do not create five simultaneous thesis projects.
- Use a two-week or one-cycle minimal validation before committing major resources.
- If results are null, first audit measurement validity, power, manipulation strength, and implementation fidelity; do not immediately rewrite the hypothesis.
- If a project stalls, return to the latest satisfied gate and identify the smallest evidence gap that blocks progress.
- Before advancing, run `validate-stage.ps1`. It checks required content or data rows, not only filenames; human review remains mandatory for scientific correctness.

## 6. Degree-program milestones and profile migration

Use `00-admin/milestones.csv` for institution-specific checkpoints. Default Chinese-program labels cover task book or training plan, proposal, midterm/annual review, pre-defense, external review, thesis submission, defense, and archive. Replace or waive them only against the actual school policy; record evidence paths and approvals.

Use `00-admin/weekly-log.md` for evidence produced, failures, decisions, and next actions. Use `meetings.md` for supervisor decisions and due dates. Use `ai-use-log.csv` for material AI assistance and disclosure status.

When the degree, discipline, track, stage, or graduation target changes:

1. Run `update-research-project.ps1` rather than editing scattered headers.
2. Let the updater atomically change `project.json`, append the decision log, synchronize generated headers, add newly required files, and regenerate status.
3. Retain older track files as historical material. Their presence does not mean the old track is still active.
4. Revalidate the active stage under the new track and institution requirements.
