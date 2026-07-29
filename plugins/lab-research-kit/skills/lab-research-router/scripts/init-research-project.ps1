[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $false)]
    [string]$Path = '.',

    [Parameter(Mandatory = $false)]
    [string]$Title = 'Untitled research project',

    [Parameter(Mandatory = $false)]
    [ValidateSet('Bachelor', 'Master', 'Doctoral', 'Other')]
    [string]$Degree = 'Other',

    [Parameter(Mandatory = $false)]
    [ValidateSet('Literature', 'Empirical', 'WetLab', 'Computational', 'Engineering', 'Design', 'General')]
    [string]$Track = 'General',

    [Parameter(Mandatory = $false)]
    [string]$Discipline = 'Unspecified',

    [Parameter(Mandatory = $false)]
    [ValidateSet('intake', 'topic', 'proposal', 'experiment', 'execution', 'analysis', 'writing', 'review', 'defense')]
    [string]$CurrentStage = 'intake',

    [Parameter(Mandatory = $false)]
    [string]$Institution = 'Unspecified',

    [Parameter(Mandatory = $false)]
    [string]$ExpectedGraduation = 'Unspecified'
)

$ErrorActionPreference = 'Stop'
$projectRoot = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
$researchRoot = Join-Path $projectRoot 'research'
$statePath = Join-Path $researchRoot 'project.json'
$created = New-Object System.Collections.Generic.List[string]
$skipped = New-Object System.Collections.Generic.List[string]
$utf8 = New-Object System.Text.UTF8Encoding($false)

$rootPath = [System.IO.Path]::GetPathRoot($projectRoot)
if ($projectRoot.TrimEnd('\', '/') -eq $rootPath.TrimEnd('\', '/')) {
    throw "Refusing to initialize a research workspace at a filesystem root: $projectRoot"
}
if (Test-Path -LiteralPath $projectRoot -PathType Leaf) {
    throw "Project path points to a file: $projectRoot"
}
foreach ($entry in @{
    Title = $Title
    Discipline = $Discipline
    Institution = $Institution
    ExpectedGraduation = $ExpectedGraduation
}.GetEnumerator()) {
    if ([string]$entry.Value -match '[\r\n]') { throw "$($entry.Key) must be a single-line value." }
}

$existingState = $null
if (Test-Path -LiteralPath $statePath -PathType Leaf) {
    $existingState = Get-Content -LiteralPath $statePath -Raw | ConvertFrom-Json
    if ($existingState.schema_version -ne 1) {
        throw "Unsupported project schema version: $($existingState.schema_version)"
    }
    $requestedProfile = [ordered]@{
        Title = @($PSBoundParameters.ContainsKey('Title'), [string]$existingState.project.title, $Title)
        Degree = @($PSBoundParameters.ContainsKey('Degree'), [string]$existingState.student.degree, $Degree)
        Track = @($PSBoundParameters.ContainsKey('Track'), [string]$existingState.project.track, $Track)
        Discipline = @($PSBoundParameters.ContainsKey('Discipline'), [string]$existingState.project.discipline, $Discipline)
        CurrentStage = @($PSBoundParameters.ContainsKey('CurrentStage'), [string]$existingState.workflow.stage, $CurrentStage)
        Institution = @($PSBoundParameters.ContainsKey('Institution'), [string]$existingState.student.institution, $Institution)
        ExpectedGraduation = @($PSBoundParameters.ContainsKey('ExpectedGraduation'), [string]$existingState.student.expected_graduation, $ExpectedGraduation)
    }
    foreach ($item in $requestedProfile.GetEnumerator()) {
        if ($item.Value[0] -and $item.Value[1] -ne [string]$item.Value[2]) {
            throw "Project $($item.Key) is '$($item.Value[1])', but '$($item.Value[2])' was requested. Use update-research-project.ps1 for profile changes."
        }
    }
    $Title = $existingState.project.title
    $Degree = $existingState.student.degree
    $Track = $existingState.project.track
    $Discipline = $existingState.project.discipline
    $CurrentStage = $existingState.workflow.stage
    $Institution = $existingState.student.institution
    $ExpectedGraduation = $existingState.student.expected_graduation
}

function Add-TemplateFile {
    param(
        [Parameter(Mandatory = $true)][string]$RelativePath,
        [Parameter(Mandatory = $true)][string]$Content
    )

    $target = Join-Path $researchRoot $RelativePath
    if (Test-Path -LiteralPath $target) {
        $skipped.Add($target)
        return
    }

    $parent = Split-Path -Parent $target
    if ($PSCmdlet.ShouldProcess($target, 'Create research template')) {
        [System.IO.Directory]::CreateDirectory($parent) | Out-Null
        [System.IO.File]::WriteAllText($target, $Content, $utf8)
        $created.Add($target)
    }
}

$today = (Get-Date).ToString('yyyy-MM-dd')
$header = @"
# $Title

- Canonical state: `research/project.json`
- Degree: $Degree
- Track: $Track
- Discipline: $Discipline
- Initialized: $today
- Evidence labels: verified / user-provided / inference / proposal / unresolved
"@

$now = (Get-Date).ToString('o')
$stateObject = if ($existingState) { $existingState } else {
    [ordered]@{
        schema_version = 1
        plugin_version = '2.2.0'
        project_id = [guid]::NewGuid().ToString()
        created_at = $now
        updated_at = $now
        student = [ordered]@{
            degree = $Degree
            institution = $Institution
            expected_graduation = $ExpectedGraduation
        }
        project = [ordered]@{
            title = $Title
            discipline = $Discipline
            track = $Track
        }
        workflow = [ordered]@{
            stage = $CurrentStage
            mode = 'coach'
            health = 'unknown'
            current_blocker = 'unresolved'
            next_gate = 'Complete intake and confirm the bounded research question.'
        }
    }
}
$stateJson = ($stateObject | ConvertTo-Json -Depth 8) + [Environment]::NewLine

$milestoneRows = New-Object System.Collections.Generic.List[string]
$milestoneRows.Add('milestone,required,due_date,owner,status,evidence_path,notes')
$degreeMilestones = switch ($Degree) {
    'Bachelor' { @('task-book', 'proposal', 'midterm', 'thesis-submission', 'defense', 'archive') }
    'Master' { @('training-plan', 'proposal', 'midterm', 'pre-defense', 'external-review', 'thesis-submission', 'defense', 'archive') }
    'Doctoral' { @('training-plan', 'proposal', 'annual-review', 'midterm', 'pre-defense', 'external-review', 'thesis-submission', 'defense', 'archive') }
    default { @('proposal', 'midterm', 'submission', 'defense', 'archive') }
}
foreach ($milestone in $degreeMilestones) {
    $milestoneRows.Add("$milestone,yes,unresolved,student,not-started,,")
}
$milestonesCsv = ($milestoneRows -join [Environment]::NewLine) + [Environment]::NewLine

$templates = [ordered]@{
    'project.json' = $stateJson
    '00-admin/research-brief.md' = "$header`n`n## Research question`n`n[unresolved]`n`n## Constraints`n`n- Deadline:`n- Institution rubric/template:`n- Budget:`n- Samples/data/materials:`n- Equipment/compute/software:`n- Approvals/permissions:`n`n## Deliverable and success criteria`n`n[unresolved]`n"
    '00-admin/decision-log.md' = "# Decision log`n`n| Date | Decision/change | Evidence and rationale | Impact | Approved by | Status |`n|---|---|---|---|---|---|`n"
    '00-admin/status.md' = "# Research status`n`n> Generated view. Run scripts/research-status.ps1 -Write after changing research/project.json.`n`n- Current stage: $CurrentStage`n- Health: unknown`n- Current blocker: unresolved`n- Next gate: Complete intake and confirm the bounded research question.`n"
    '00-admin/milestones.csv' = $milestonesCsv
    '00-admin/weekly-log.md' = "# Weekly progress log`n`n| Week/date | Completed evidence | Decisions | Problems/failures | Next actions | Supervisor input |`n|---|---|---|---|---|---|`n"
    '00-admin/meetings.md' = "# Supervisor and collaboration meetings`n`n| Date | Participants | Decisions | Evidence requested | Actions | Owner | Due |`n|---|---|---|---|---|---|---|`n"
    '00-admin/ai-use-log.csv' = "date,tool,model_or_version,purpose,input_classification,artifact,human_verification,material_change,disclosure_status,notes`n"
    '01-topic/topic-candidates.md' = "# Topic candidates`n`n| Candidate RQ | Importance | Honest contribution | Falsifiability/assessment | Feasibility | Identifiability | Risk | Decision |`n|---|---:|---:|---:|---:|---:|---:|---|`n"
    '01-topic/novelty-audit.md' = "# Novelty audit`n`n## Search boundary`n`n- Databases/sources:`n- Date range:`n- Queries:`n- Inclusion/exclusion:`n- Retrieval date:`n`n## Nearest work`n`n| Source ID | Stable identifier | Closest overlap | Remaining difference | Claim-support status |`n|---|---|---|---|---|`n"
    '02-evidence/evidence-matrix.csv' = "source_id,stable_identifier,source_type,research_question,material_or_population,method,comparison,endpoint,finding,limitation,locator,status,notes`n"
    '03-proposal/proposal-outline.md' = "$header`n`n## Problem and significance`n`n## Verified state of the field`n`n## Search-bounded gap or design need`n`n## Research question, objective, or design brief`n`n## Work objectives`n`n## Methods, implementation, evaluation, and analysis`n`n## Honest contribution`n`n## Feasibility, approvals, and risks`n`n## Schedule and outputs`n"
    '03-proposal/technical-route.md' = "# Technical route`n`n| Objective | Input/material | Method/action | Comparator/criterion | Primary output | Measurement/evaluation | Analysis | Success/pivot rule |`n|---|---|---|---|---|---|---|---|`n"
    '06-manuscript/claim-evidence-map.md' = "# Claim-evidence map`n`n| Claim ID | Claim | Type | Evidence/source | Locator | Status | Strength limit | Used in |`n|---|---|---|---|---|---|---|---|`n"
    '06-manuscript/paper-outline.md' = "# Thesis, paper, or capstone outline`n`n| Section | Reader question | Section claim | Required evidence | Status |`n|---|---|---|---|---|`n"
    '06-manuscript/manuscript.md' = "$header`n`n> Draft only. Do not add unverified citations, data, implementation claims, experiments, or results.`n"
    '07-review/review-matrix.csv' = "id,source,locator,severity,issue,risk,evidence_needed,action,owner,status,response_locator`n"
    '08-defense/defense-outline.md' = "# Defense outline`n`n| Time | Slide/section | Take-home claim | Evidence | Limitation |`n|---|---|---|---|---|`n"
    '08-defense/questions.md' = "# Defense question cards`n`n| Category | Question | Position | Evidence | Boundary | Next action |`n|---|---|---|---|---|---|`n"
    '04-experiments/design-brief.md' = "$header`n`n## Question, hypothesis/objective, and alternatives`n`n## Experimental and observation units`n`n## Endpoints and meaningful effect/criterion`n`n## Controls, comparison, and replication`n`n## Design family and rationale`n`n## Sampling/randomization, blocking, and blinding`n`n## QC, failures, missingness, exclusions, and deviations`n`n## Ethics, safety, privacy, and approvals`n"
    '04-experiments/factors-and-controls.csv' = "name,role,type,levels_or_range,unit,manipulation_or_measurement,rationale,confounding_risk,status`n"
    '04-experiments/randomization.csv' = "unit_id,block,batch,assigned_condition,run_order,blind_label,seed,tool_version,status,deviation`n"
    '04-experiments/statistical-analysis-plan.md' = "# Statistical analysis plan`n`n## Objective, hypothesis, and estimand`n`n## Primary endpoint and unit of analysis`n`n## Sample-size/information-sufficiency assumptions and sensitivity`n`n## Model, factors, covariates, interactions, and random effects`n`n## Missing data, detection limits, outliers, and exclusions`n`n## Multiplicity and uncertainty reporting`n`n## Sensitivity and exploratory analyses`n`n## Software, versions, code, and outputs`n"
    '04-experiments/experiment-log.md' = "# Study or experiment log`n`n| Date/time | Run/study ID | Design version | Material/data/batch | Operator | Protocol/instrument | Raw-evidence path | QC | Deviations/failures | Status |`n|---|---|---|---|---|---|---|---|---|---|`n"
    '05-analysis/analysis-log.md' = "# Analysis log`n`n| Date | Analysis ID | Plan version | Data/evidence version | Code revision | Command/notebook | Output | Confirmatory/exploratory | Checks | Notes |`n|---|---|---|---|---|---|---|---|---|---|`n"
    '04-experiments/implementation-plan.md' = "# Engineering implementation plan`n`n## Requirements and acceptance criteria`n`n## Architecture and interfaces`n`n## Baseline and alternatives`n`n## Milestones and versioning`n`n## Verification, validation, performance, reliability, and security`n`n## Risks, fallback, and demo evidence`n"
    '04-experiments/test-matrix.csv' = "requirement_id,requirement,method,test_case,expected_result,actual_evidence,status,version,notes`n"
    '04-experiments/design-process.md' = "# Design process`n`n## Users, context, and evidence`n`n## Design brief and criteria`n`n## Concepts and decision rationale`n`n## Iterations and feedback`n`n## Final artifact and production record`n`n## Accessibility, ethics, copyright, and limitations`n"
    '04-experiments/evaluation-plan.md' = "# Design evaluation plan`n`n| Criterion | Evidence/source | Evaluation method | Participant/material | Success indicator | Limitation | Status |`n|---|---|---|---|---|---|---|`n"
    '07-review/rebuttal.md' = "# Rebuttal or revision response`n`n| Comment ID | Response position | Evidence | Change | Manuscript locator | Status |`n|---|---|---|---|---|---|`n"
    '00-admin/research-program.md' = "# Doctoral research program`n`n## Program-level question and contribution`n`n## Linked work packages`n`n## Cross-study evidence and integration`n`n## Validation, publication, and dependency strategy`n`n## Program risks, amendments, and decision gates`n"
    '03-proposal/work-packages.md' = "# Doctoral work packages`n`n| WP | Question/contribution | Inputs | Method | Evidence/output | Dependency | Gate | Status |`n|---|---|---|---|---|---|---|---|`n"
}

$selected = New-Object System.Collections.Generic.List[string]
$coreFiles = @(
    'project.json',
    '00-admin/research-brief.md',
    '00-admin/decision-log.md',
    '00-admin/status.md',
    '00-admin/milestones.csv',
    '00-admin/weekly-log.md',
    '00-admin/meetings.md',
    '00-admin/ai-use-log.csv',
    '01-topic/topic-candidates.md',
    '01-topic/novelty-audit.md',
    '02-evidence/evidence-matrix.csv',
    '03-proposal/proposal-outline.md',
    '03-proposal/technical-route.md',
    '06-manuscript/claim-evidence-map.md',
    '06-manuscript/paper-outline.md',
    '06-manuscript/manuscript.md',
    '07-review/review-matrix.csv',
    '08-defense/defense-outline.md',
    '08-defense/questions.md'
)
foreach ($file in $coreFiles) { $selected.Add($file) }

if ($Track -in @('Empirical', 'WetLab', 'Computational')) {
    foreach ($file in @(
        '04-experiments/design-brief.md',
        '04-experiments/factors-and-controls.csv',
        '04-experiments/randomization.csv',
        '04-experiments/statistical-analysis-plan.md',
        '04-experiments/experiment-log.md',
        '05-analysis/analysis-log.md'
    )) { $selected.Add($file) }
}

if ($Track -eq 'Engineering') {
    foreach ($file in @(
        '04-experiments/implementation-plan.md',
        '04-experiments/test-matrix.csv',
        '05-analysis/analysis-log.md'
    )) { $selected.Add($file) }
}

if ($Track -eq 'Design') {
    foreach ($file in @(
        '04-experiments/design-process.md',
        '04-experiments/evaluation-plan.md',
        '05-analysis/analysis-log.md'
    )) { $selected.Add($file) }
}

if ($Degree -in @('Master', 'Doctoral')) {
    $selected.Add('07-review/rebuttal.md')
}

if ($Degree -eq 'Doctoral') {
    $selected.Add('00-admin/research-program.md')
    $selected.Add('03-proposal/work-packages.md')
}

foreach ($relativePath in $selected) {
    Add-TemplateFile -RelativePath $relativePath -Content $templates[$relativePath]
}

[pscustomobject]@{
    project_root = $projectRoot
    research_root = $researchRoot
    degree = $Degree
    track = $Track
    stage = $CurrentStage
    project_id = $stateObject.project_id
    canonical_state = $statePath
    selected_count = $selected.Count
    created_count = $created.Count
    skipped_existing_count = $skipped.Count
    created = @($created)
    skipped_existing = @($skipped)
}
