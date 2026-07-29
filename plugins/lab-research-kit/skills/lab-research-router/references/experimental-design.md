# Experimental design for wet-lab and multifactor research

Use this reference for biological, biochemical, chemical, medical, agricultural, materials, environmental, cell, animal, assay, instrument, and computational experiments. It supports design and analysis planning; it is not a substitute for approved protocols, training, supervision, ethics, or safety authorization.

## Contents

1. Design brief
2. Units, controls, and replication
3. Choose a design family
4. Multifactor and optimization workflow
5. Sample size and power
6. Randomization, blocking, and blinding
7. Statistical analysis plan
8. Wet-lab quality and safety gates
9. Completion checklist

## 1. Design brief

Define before choosing a statistical test:

- scientific question and causal or descriptive target;
- hypothesis and plausible competing explanations;
- experimental unit and observation unit;
- factors, levels, ranges, and whether each is fixed, random, controllable, or nuisance;
- primary endpoint, secondary endpoints, measurement timing, scale, and minimally meaningful effect;
- controls, baseline, reference method, and quality-control samples;
- resource constraints, throughput, batches, missingness, attrition, and stopping rules;
- confirmatory versus exploratory status.

Create `factors-and-controls.csv` with: `name,role,type,levels_or_range,unit,manipulation_or_measurement,rationale,confounding_risk,status`.

## 2. Units, controls, and replication

Distinguish:

- **Experimental unit**: smallest independently randomized unit receiving a condition.
- **Biological/independent replicate**: independent source unit supporting population inference.
- **Technical replicate**: repeated measurement or processing of the same experimental unit; estimates measurement variability but does not increase independent sample size.
- **Subsample**: multiple observations within one unit; model nesting or aggregate according to the estimand.
- **Batch**: run, plate, day, operator, litter, site, instrument, reagent lot, or other shared condition.

Select controls by the claim:

- negative or vehicle control for background;
- positive control for assay sensitivity;
- blank control for contamination/background signal;
- reference/baseline for comparative performance;
- sham or procedural control when the procedure itself may cause effects;
- batch and quality-control samples for drift and calibration.

Do not add controls mechanically. State what failure or alternative explanation each control detects.

## 3. Choose a design family

| Need | Candidate design | Key limitation |
|---|---|---|
| One factor, few levels | Completely randomized one-factor design | Cannot estimate interactions with omitted factors |
| Several factors and interactions matter | Full factorial | Runs grow as the product of levels |
| Screen many factors cheaply | Fractional factorial or screening design | Some effects are aliased; resolution must be stated |
| Balance discrete factors with limited runs | Orthogonal array | Interactions may be unidentifiable or confounded |
| Optimize continuous factors after screening | Response surface, central composite, or Box–Behnken | Local model; requires justified ranges and model checks |
| Known nuisance heterogeneity | Randomized block design | Block × treatment interactions may need modeling |
| Same unit measured repeatedly | Repeated-measures or longitudinal design | Correlation and missingness must be modeled |
| Hierarchical units/batches/sites | Multilevel or mixed-effects design | Needs enough higher-level units for stable variance estimates |
| Sequential learning under cost constraints | Staged or adaptive design | Adaptation rules must be predeclared for confirmatory claims |
| Estimate equivalence/non-inferiority | Equivalence/non-inferiority design | Margin must be justified before data inspection |

The design name alone is insufficient. Record the estimable effects, aliases, interactions omitted, model assumptions, and conclusions the design cannot support.

## 4. Multifactor and optimization workflow

1. Define the response and scientifically plausible interactions.
2. Set factor ranges using domain evidence, instrument limits, pilot data, and safety constraints.
3. Remove factors that cannot be controlled or measured reliably; model unavoidable nuisance factors.
4. Calculate the full-factorial run count: multiply all level counts, then multiply by independent replication. Add quality-control, calibration, attrition, and failed-run allowance separately.
5. If the run count is infeasible, choose screening or an orthogonal/fractional design based on which interactions may be sacrificed.
6. After screening, validate important effects in an independent or confirmatory stage.
7. Use response-surface methods only after relevant continuous factors and safe ranges are established.
8. Confirm a predicted optimum with independent runs; report uncertainty and boundary behavior.

For three factors with 3, 3, and 4 levels, a full factorial has `3 × 3 × 4 = 36` treatment combinations. Three independent replicates imply 108 experimental units before controls and losses. Do not call three wells from one preparation three independent replicates.

When proposing an orthogonal array or fractional design, provide:

- factor-to-column assignment;
- design resolution or alias structure where applicable;
- interactions that can and cannot be estimated;
- randomization and blocking plan;
- analysis model;
- confirmation experiment.

## 5. Sample size and power

Do not produce a final sample size from convention alone. Document:

- primary endpoint and planned model/test;
- experimental unit;
- minimally meaningful effect or equivalence margin;
- variance, event rate, intraclass correlation, or other nuisance assumptions and their source;
- alpha, target power, sidedness, allocation ratio, number of comparisons, clustering/repeated measures;
- attrition, assay failure, exclusion, and unusable-sample allowance;
- sensitivity analysis over uncertain assumptions.

If effect size or variance is unknown, design a pilot for feasibility and variance estimation rather than claiming it proves efficacy. Small pilots give unstable variance estimates; show a range of resulting sample sizes and seek statistical review for high-stakes studies.

For multifactor work, power the primary effect or interaction that answers the main question. “Enough total observations” does not repair too few independent units within cells or too few batches/clusters.

## 6. Randomization, blocking, and blinding

- Randomize at the experimental-unit level, not the measurement-row level.
- Block on strong known nuisance variables such as batch, plate, day, site, litter, operator, or baseline severity.
- Balance conditions across plates, positions, days, and operators when possible.
- Generate the allocation only after inclusion criteria and unit IDs are frozen.
- Keep seed, tool/version, constraints, allocation, deviations, and who had access.
- Blind treatment labels during measurement and/or analysis when feasible; record where blinding breaks.
- Do not randomize away a safety constraint; encode it explicitly and disclose the restriction.

## 7. Statistical analysis plan

Write before confirmatory data inspection:

1. objective, hypothesis, estimand, and primary endpoint;
2. unit of analysis and data structure;
3. factor coding, contrasts, covariates, blocks, random effects, and planned interactions;
4. model and assumption checks;
5. missing data, below-detection values, outliers, exclusions, and protocol deviations;
6. multiplicity and family definition;
7. effect estimates, confidence/credible intervals, exact p-values when used, and practical relevance;
8. sensitivity and robustness analyses;
9. exploratory analyses clearly separated;
10. software, package versions, code path, and reproducibility outputs.

Prefer a model matching the design over a sequence of unrelated pairwise tests. For factorial designs, inspect interaction terms before interpreting marginal main effects. For repeated or clustered measurements, model correlation rather than treating rows as independent.

## 8. Wet-lab quality and safety gates

Before operational detail, require the user's approved SOP and institutional context when the work involves pathogens, toxins, hazardous chemicals, human/animal material, genetic modification, controlled substances, environmental release, or other regulated/high-risk procedures.

Plan quality controls without inventing operating parameters:

- material identity, lot, storage, expiry, and chain of custody;
- equipment calibration and maintenance status;
- assay acceptance range and invalid-run rule;
- contamination, carryover, positional, drift, and batch checks;
- raw-data capture, sample naming, time stamps, and audit trail;
- deviation, failure, repeat, and exclusion policy;
- approved waste, incident, and escalation route.

Never infer that approval exists. Mark ethics, biosafety, animal, chemical, clinical, privacy, and facility authorization as `verified`, `user-provided`, or `unresolved`.

## 9. Completion checklist

- The design answers the stated RQ and distinguishes key alternatives.
- Experimental and observation units are explicit.
- Controls have stated purposes.
- Independent, technical, nested, and batch replication are separated.
- Factor ranges and interactions are justified.
- Sample-size assumptions and sensitivity are documented.
- Randomization, blocking, blinding, and run order are reproducible.
- Primary analysis is frozen before confirmatory inspection.
- QC, missingness, failure, repeat, and deviation rules are explicit.
- Safety/ethics approvals and accountable humans are visible.
- Raw data and analysis artifacts have planned locations.
