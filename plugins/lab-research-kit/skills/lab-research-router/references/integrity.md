# Research integrity and evidence policy

Use this policy for every literature, citation, database, experiment, statistics, manuscript, review, clinical, or patent task.

## Evidence labels

| Label | Meaning | Allowed use |
|---|---|---|
| `verified` | Directly inspected primary source, trusted database record, local source file, or executed calculation | May support a factual statement with a locator |
| `user-provided` | Supplied by the user but not independently checked | May be quoted as user material; do not upgrade to verified |
| `inference` | Reasoned from stated inputs | State assumptions and uncertainty |
| `proposal` | Untested idea, query, hypothesis, draft, or plan | Never present as a finding |
| `unresolved` | Missing, inaccessible, stale, or conflicting evidence | Keep visible and specify how to resolve |

## Source hierarchy

Prefer the narrowest authoritative source available:

1. Original paper, dataset documentation, protocol, code release, registry record, standard, or official database entry.
2. Publisher metadata, Crossref, PubMed, clinical-trial registry, patent office, or another authoritative index.
3. Reputable secondary review that clearly cites primary evidence.
4. Search result or model summary only as a discovery lead, never as final support.

For mutable online facts, record the retrieval date. For database queries, record the database, endpoint or interface, query, filters, identifier type, result count, and retrieval time.

## Citation verification gate

Before including a citation as verified, check as many fields as the task requires:

- title;
- author list or first author and group;
- year;
- venue or publisher;
- DOI, PMID, arXiv ID, trial ID, patent number, accession, or another stable identifier;
- the exact claim supported by the source;
- a locator such as section, figure, table, page, paragraph, or database field.

Do not infer a DOI from a title pattern. Do not invent missing bibliographic fields. If the full text was not inspected, say `metadata verified; claim support unresolved`.

## Literature search gate

Separate planning from execution:

- A search plan contains databases, date range, query strings, inclusion and exclusion criteria, deduplication rules, and planned fields.
- A search result contains the actual retrieval time, returned records, screening decisions, exclusions with reasons, and source exports.

Never turn the first into the second. Preserve raw exports when possible. Keep the inclusion criteria stable, or log and justify changes before rescreening.

## Experiment gate

Before claiming an experimental result, record:

- hypothesis and endpoint;
- baseline and comparison;
- code revision or artifact hash;
- environment and dependency versions;
- data version and split;
- random seed and run count;
- exact command or protocol;
- raw result location;
- analysis script and metric definition;
- failures, exclusions, and deviations.

Do not cherry-pick runs or silently replace the endpoint. Distinguish exploratory from confirmatory analysis. Generated example numbers must be marked synthetic and must not resemble reported findings without a warning.

For wet-lab or field work, additionally record the experimental unit, observation unit, biological/independent repeats, technical repeats, nested samples, batches, controls, randomization, blinding, material identity, instrument or assay QC, deviations, repeats, exclusions, and approval status. A project file describing an experiment is not evidence that the experiment ran.

## Statistical gate

Verify the experimental unit, independence assumptions, sample size, missing-data handling, test assumptions, multiple-comparison procedure, effect size, uncertainty interval, and exact p-value reporting. Do not use `significant` without the stated analysis and threshold. Do not infer causality from association.

For multifactor designs, document estimable effects, planned interactions, aliases or confounding, blocks/random effects, factor ranges, run count, and confirmation strategy. Inspect interactions before interpreting marginal main effects. Do not treat technical repeats, wells, repeated time points, image fields, or subsamples from one independent unit as added independent sample size.

Treat a computed sample size as a conditional result. Record the endpoint, model, minimally meaningful effect, variance/event-rate/ICC assumption and source, alpha, power, sidedness, allocation, multiplicity, clustering, attrition, and sensitivity range. If these inputs are missing, return a sample-size plan rather than a definitive number.

## Writing and review gate

Preserve the author's meaning and distinguish language editing from scientific revision. When reviewing, tie each actionable concern to a concrete locator and explain the risk. When drafting rebuttals, do not claim a new experiment has been run until its files and results exist.

## Clinical and sensitive data

Treat biomedical research support as informational and evidence-oriented, not patient-specific medical advice. Do not expose patient identifiers, private datasets, credentials, or embargoed manuscripts to external tools without explicit authorization and an approved data-handling path.

For pathogens, toxins, hazardous chemicals, human or animal materials, genetic modification, controlled substances, environmental release, or other regulated/high-risk work, require the applicable approved SOP, trained supervision, facility controls, and institutional authorization before providing operational detail. Never infer that ethics, biosafety, animal, chemical, clinical, privacy, or facility approval exists.

## AI disclosure and authorship

Follow the user's institution, funder, conference, and journal policies. Keep a lightweight AI-use record when required: tool, date, purpose, affected artifact, human verification, and whether content or analysis changed. Do not list an AI system as an author unless an applicable policy explicitly requires it.

## Stop conditions

Stop or return an unresolved item when:

- the requested source cannot be accessed;
- database identifiers conflict;
- the user asks to fabricate data or citations;
- experimental evidence is missing;
- a clinical request becomes individualized diagnosis or treatment;
- required authorization for sensitive data or external transmission is absent.
