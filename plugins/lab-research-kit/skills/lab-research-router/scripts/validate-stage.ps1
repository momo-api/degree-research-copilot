[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$Path = '.',

    [Parameter(Mandatory = $false)]
    [ValidateSet('intake', 'topic', 'proposal', 'experiment', 'execution', 'analysis', 'writing', 'review', 'defense')]
    [string]$Stage,

    [switch]$Json
)

$ErrorActionPreference = 'Stop'
$projectRoot = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
$researchRoot = Join-Path $projectRoot 'research'
$statePath = Join-Path $researchRoot 'project.json'
if (-not (Test-Path -LiteralPath $statePath -PathType Leaf)) {
    throw "Canonical project state was not found: $statePath"
}

$state = Get-Content -LiteralPath $statePath -Raw | ConvertFrom-Json
if (-not $Stage) { $Stage = $state.workflow.stage }
$checks = New-Object System.Collections.Generic.List[object]

function Add-Check {
    param([string]$Id, [bool]$Passed, [string]$Message, [string]$PathValue)
    $checks.Add([pscustomobject]@{ id = $Id; passed = $Passed; message = $Message; path = $PathValue })
}

function Test-MaterialMarkdown {
    param([string]$RelativePath, [int]$MinimumLines = 1)
    $file = Join-Path $researchRoot $RelativePath
    if (-not (Test-Path -LiteralPath $file -PathType Leaf)) {
        Add-Check "file:$RelativePath" $false 'Required file is missing.' $file
        return
    }
    $material = @(Get-Content -LiteralPath $file | Where-Object {
        $line = $_.Trim()
        $line -and
        $line -notmatch '^#' -and
        $line -notmatch '^>' -and
        $line -notmatch '^\|?\s*[-:]+(?:\s*\|\s*[-:]+)*\s*\|?$' -and
        $line -notmatch '^\[unresolved\]$' -and
        $line -notmatch '^\[EVIDENCE NEEDED\]$' -and
        $line -notmatch '^- (Canonical state|Degree|Track|Discipline|Initialized|Evidence labels):' -and
        $line -notmatch '^-[^:]+:\s*$' -and
        $line -notmatch '^\|.*(?:Candidate RQ|Source ID|Objective|Claim ID|Section|Time|Category|Date/time|Date \|).*$'
    })
    Add-Check "content:$RelativePath" ($material.Count -ge $MinimumLines) "Material lines: $($material.Count); required: $MinimumLines." $file
}

function Test-CsvRows {
    param([string]$RelativePath, [int]$MinimumRows = 1)
    $file = Join-Path $researchRoot $RelativePath
    if (-not (Test-Path -LiteralPath $file -PathType Leaf)) {
        Add-Check "file:$RelativePath" $false 'Required CSV is missing.' $file
        return
    }
    $rows = @(Import-Csv -LiteralPath $file)
    Add-Check "rows:$RelativePath" ($rows.Count -ge $MinimumRows) "Data rows: $($rows.Count); required: $MinimumRows." $file
}

Add-Check 'canonical-state' ($state.schema_version -eq 1) "Schema version: $($state.schema_version)." $statePath

switch ($Stage) {
    'intake' {
        Test-MaterialMarkdown '00-admin\research-brief.md' 3
    }
    'topic' {
        Test-MaterialMarkdown '01-topic\topic-candidates.md' 1
        Test-MaterialMarkdown '01-topic\novelty-audit.md' 5
    }
    'proposal' {
        Test-MaterialMarkdown '03-proposal\proposal-outline.md' 8
        Test-MaterialMarkdown '03-proposal\technical-route.md' 1
    }
    'experiment' {
        if ($state.project.track -in @('Empirical', 'WetLab', 'Computational')) {
            Test-MaterialMarkdown '04-experiments\design-brief.md' 8
            Test-MaterialMarkdown '04-experiments\statistical-analysis-plan.md' 6
            Test-CsvRows '04-experiments\factors-and-controls.csv' 1
        } elseif ($state.project.track -eq 'Engineering') {
            Test-MaterialMarkdown '04-experiments\implementation-plan.md' 5
            Test-CsvRows '04-experiments\test-matrix.csv' 1
        } elseif ($state.project.track -eq 'Design') {
            Test-MaterialMarkdown '04-experiments\design-process.md' 5
            Test-MaterialMarkdown '04-experiments\evaluation-plan.md' 1
        } else {
            Add-Check 'track-experiment-applicability' $false "Track '$($state.project.track)' has no default experiment gate." $statePath
        }
    }
    'execution' {
        if ($state.project.track -in @('Empirical', 'WetLab', 'Computational')) {
            Test-MaterialMarkdown '04-experiments\experiment-log.md' 1
        } elseif ($state.project.track -eq 'Engineering') {
            Test-CsvRows '04-experiments\test-matrix.csv' 1
        } elseif ($state.project.track -eq 'Design') {
            Test-MaterialMarkdown '04-experiments\design-process.md' 5
        } else {
            Add-Check 'track-execution-applicability' $false "Track '$($state.project.track)' needs a user-defined execution record." $statePath
        }
    }
    'analysis' {
        Test-MaterialMarkdown '05-analysis\analysis-log.md' 1
    }
    'writing' {
        Test-MaterialMarkdown '06-manuscript\claim-evidence-map.md' 1
        Test-MaterialMarkdown '06-manuscript\paper-outline.md' 1
        Test-MaterialMarkdown '06-manuscript\manuscript.md' 5
    }
    'review' {
        Test-CsvRows '07-review\review-matrix.csv' 1
    }
    'defense' {
        Test-MaterialMarkdown '08-defense\defense-outline.md' 1
        Test-MaterialMarkdown '08-defense\questions.md' 1
    }
}

$failed = @($checks | Where-Object { -not $_.passed })
$result = [pscustomobject]@{
    project_id = $state.project_id
    stage = $Stage
    track = $state.project.track
    passed = ($failed.Count -eq 0)
    total_checks = $checks.Count
    failed_checks = $failed.Count
    checks = $checks.ToArray()
}

if ($Json) { $result | ConvertTo-Json -Depth 6 } else { $result }
if (-not $result.passed) { exit 2 }
