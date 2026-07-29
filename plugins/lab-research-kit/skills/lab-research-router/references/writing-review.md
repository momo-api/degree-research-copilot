# Thesis, paper, review, and defense workflow

Use this reference after a research question exists or when the user supplies literature, data, results, a draft, reviewer comments, or a defense requirement.

## 1. Diagnose before drafting

Do not start with fluent prose. Establish:

- target reader, institution/venue, genre, language, length, and template;
- precise research question and approved scope;
- contribution statement and its evidence status;
- available literature, methods, data, results, figures, code, and approvals;
- missing evidence that blocks strong claims;
- whether the user requests planning, editing, drafting, auditing, or coaching.

If only a broad direction exists, return to topic scoping. If results do not exist, write methods, rationale, and proposed analyses in future/proposal language rather than fabricating a results section.

## 2. Build the claim-evidence map

Create one row per material claim:

| Claim ID | Claim | Type | Evidence/source | Locator | Status | Strength limit | Used in |
|---|---|---|---|---|---|---|---|

Types include background fact, gap, method choice, measured result, comparative result, mechanism, generalization, limitation, and implication.

Status uses `verified`, `user-provided`, `inference`, `proposal`, or `unresolved`. A citation's existence and its support for the exact claim are separate checks.

## 3. Design the argument

Use this spine:

```text
Important problem
→ what the closest work establishes
→ precise unresolved gap
→ research question and approach
→ fair evidence
→ bounded conclusion
→ limitation and implication
```

Assign each section one job. Use conclusion-style headings where appropriate. Keep methods reproducible, results descriptive before interpretive, and discussion broader only to the extent supported.

## 4. Draft and revise in passes

1. **Structure pass** — section purpose, order, missing logic.
2. **Evidence pass** — claim-source alignment, result locators, unsupported strength.
3. **Method/statistics pass** — units, controls, exclusions, models, uncertainty, reproducibility.
4. **Contribution pass** — novelty, significance, boundary, comparison fairness.
5. **Language pass** — clarity, terminology, coherence, concision, style.
6. **Format pass** — template, citations, tables, figures, captions, supplementary material.

Do not let language polishing hide scientific uncertainty. Preserve citation keys and measured values unless the underlying source or analysis is checked.

## 5. Review and rebuttal

Create `review-matrix.csv` with:

`id,source,locator,severity,issue,risk,evidence_needed,action,owner,status,response_locator`

Review scientific validity, novelty, design, statistics, reproducibility, ethics, reporting, citations, presentation, and venue fit. Separate blocking defects, required clarifications, and optional improvements.

For rebuttal:

- quote or faithfully paraphrase each comment;
- state agreement/disagreement respectfully;
- identify the exact change and manuscript locator;
- cite real evidence;
- use future/proposal language for unrun experiments;
- do not claim resolution until the artifact exists and is checked.

## 6. Defense preparation

Build a timed story rather than shrinking the thesis into slides:

1. problem and stakes;
2. gap and RQ;
3. design and decisive controls;
4. key results with uncertainty;
5. contribution and comparison;
6. limitations, validity threats, and future work;
7. take-home conclusion.

Create question cards across theory, novelty, method choice, controls, sample size, statistics, negative results, ethics/safety, generalization, limitations, and alternative explanations. Answer with `position → evidence → boundary → next action`. Mark unknowns honestly.

## 7. Completion gate

- Every central claim maps to evidence or an explicit unresolved status.
- Methods and statistics match the actual design and units.
- Figures/tables trace to data and analysis artifacts.
- Results, interpretation, speculation, and recommendations are distinguishable.
- Citations are verified at the level required by the deliverable.
- Limitations and deviations are visible.
- The human author approves the final wording and submission.
