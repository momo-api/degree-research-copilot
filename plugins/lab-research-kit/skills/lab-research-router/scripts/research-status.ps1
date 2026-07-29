[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$Path = '.',

    [switch]$Write,

    [switch]$Json
)

$ErrorActionPreference = 'Stop'
$projectRoot = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
$researchRoot = Join-Path $projectRoot 'research'
$statePath = Join-Path $researchRoot 'project.json'
$milestonesPath = Join-Path $researchRoot '00-admin\milestones.csv'
$statusPath = Join-Path $researchRoot '00-admin\status.md'
$utf8 = New-Object System.Text.UTF8Encoding($false)

if (-not (Test-Path -LiteralPath $statePath -PathType Leaf)) {
    throw "Canonical project state was not found: $statePath"
}

$state = Get-Content -LiteralPath $statePath -Raw | ConvertFrom-Json
$milestones = @()
if (Test-Path -LiteralPath $milestonesPath -PathType Leaf) {
    $milestones = @(Import-Csv -LiteralPath $milestonesPath)
}
$openMilestones = @($milestones | Where-Object { $_.status -notin @('complete', 'waived') })
$nextMilestone = $openMilestones | Where-Object { $_.due_date -and $_.due_date -ne 'unresolved' } | Sort-Object due_date | Select-Object -First 1

$result = [pscustomobject]@{
    schema_version = $state.schema_version
    plugin_version = $state.plugin_version
    project_id = $state.project_id
    title = $state.project.title
    degree = $state.student.degree
    track = $state.project.track
    discipline = $state.project.discipline
    stage = $state.workflow.stage
    mode = $state.workflow.mode
    health = $state.workflow.health
    current_blocker = $state.workflow.current_blocker
    next_gate = $state.workflow.next_gate
    expected_graduation = $state.student.expected_graduation
    open_milestones = $openMilestones.Count
    next_milestone = if ($nextMilestone) { $nextMilestone.milestone } else { $null }
    next_milestone_due = if ($nextMilestone) { $nextMilestone.due_date } else { $null }
    updated_at = $state.updated_at
}

if ($Write) {
    $nextLine = if ($nextMilestone) { "$($nextMilestone.milestone) — $($nextMilestone.due_date)" } else { 'No dated open milestone' }
    $markdown = @"
# Research status

> Generated from research/project.json. Edit the canonical state with update-research-project.ps1, then regenerate this view.

| Field | Value |
|---|---|
| Project | $($result.title) |
| Degree | $($result.degree) |
| Track | $($result.track) |
| Discipline | $($result.discipline) |
| Current stage | $($result.stage) |
| Mode | $($result.mode) |
| Health | $($result.health) |
| Current blocker | $($result.current_blocker) |
| Next gate | $($result.next_gate) |
| Expected graduation | $($result.expected_graduation) |
| Next dated milestone | $nextLine |
| Last state update | $($result.updated_at) |
"@
    [System.IO.File]::WriteAllText($statusPath, $markdown, $utf8)
}

if ($Json) { $result | ConvertTo-Json -Depth 5 } else { $result }
