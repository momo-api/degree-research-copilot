[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$SkillRoot = (Join-Path $PSScriptRoot '..')
)

$ErrorActionPreference = 'Stop'
$skillRootPath = [System.IO.Path]::GetFullPath($SkillRoot)
$pluginRoot = [System.IO.Path]::GetFullPath((Join-Path $skillRootPath '..\..'))
$initializer = Join-Path $skillRootPath 'scripts\init-research-project.ps1'
$updater = Join-Path $skillRootPath 'scripts\update-research-project.ps1'
$statusReader = Join-Path $skillRootPath 'scripts\research-status.ps1'
$stageValidator = Join-Path $skillRootPath 'scripts\validate-stage.ps1'
$caseFile = Join-Path $skillRootPath 'scripts\quality-cases.json'
$tempBase = [System.IO.Path]::GetFullPath([System.IO.Path]::GetTempPath())
$testRoot = [System.IO.Path]::GetFullPath((Join-Path $tempBase ('lab-research-router-tests-' + [guid]::NewGuid().ToString('N'))))
$results = New-Object System.Collections.Generic.List[object]

function Assert-True {
    param([bool]$Condition, [string]$Message)
    if (-not $Condition) { throw $Message }
}

function Assert-Equal {
    param($Actual, $Expected, [string]$Message)
    if ($Actual -ne $Expected) {
        throw ("{0}; expected={1}; actual={2}" -f $Message, $Expected, $Actual)
    }
}

function Invoke-UnitTest {
    param([string]$Name, [scriptblock]$Body)
    $watch = [System.Diagnostics.Stopwatch]::StartNew()
    try {
        & $Body
        $watch.Stop()
        $results.Add([pscustomobject]@{
            name = $Name
            status = 'passed'
            duration_ms = $watch.ElapsedMilliseconds
            message = $null
        })
    } catch {
        $watch.Stop()
        $results.Add([pscustomobject]@{
            name = $Name
            status = 'failed'
            duration_ms = $watch.ElapsedMilliseconds
            message = $_.Exception.Message
        })
    }
}

try {
    [System.IO.Directory]::CreateDirectory($testRoot) | Out-Null

    $skillFile = Join-Path $skillRootPath 'SKILL.md'
    $skillText = Get-Content -LiteralPath $skillFile -Raw

    Invoke-UnitTest 'required-files-exist' {
        foreach ($relative in @(
            'SKILL.md',
            'agents\openai.yaml',
            'references\degree-profiles.md',
            'references\lifecycle.md',
            'references\proposal.md',
            'references\experimental-design.md',
            'references\writing-review.md',
            'references\integrity.md',
            'scripts\init-research-project.ps1',
            'scripts\update-research-project.ps1',
            'scripts\research-status.ps1',
            'scripts\validate-stage.ps1',
            'scripts\test-quality.ps1',
            'scripts\quality-cases.json'
        )) {
            Assert-True (Test-Path -LiteralPath (Join-Path $skillRootPath $relative) -PathType Leaf) "Missing required file: $relative"
        }
    }

    Invoke-UnitTest 'frontmatter-has-only-name-description' {
        $frontmatter = [regex]::Match($skillText, '(?s)\A---\r?\n(.*?)\r?\n---')
        Assert-True $frontmatter.Success 'SKILL.md frontmatter was not found'
        $keys = @([regex]::Matches($frontmatter.Groups[1].Value, '(?m)^([A-Za-z0-9_-]+):') | ForEach-Object { $_.Groups[1].Value })
        Assert-Equal $keys.Count 2 'Unexpected number of frontmatter keys'
        Assert-True ($keys -contains 'name') 'Frontmatter is missing name'
        Assert-True ($keys -contains 'description') 'Frontmatter is missing description'
    }

    Invoke-UnitTest 'trigger-description-covers-degree-and-work-types' {
        foreach ($term in @('undergraduate', 'bachelor', 'master', 'doctoral', 'capstone', 'proposal', 'wet-lab', 'engineering', 'design', 'multifactor')) {
            Assert-True ($skillText.IndexOf($term, [System.StringComparison]::OrdinalIgnoreCase) -ge 0) "Trigger description/body is missing: $term"
        }
    }

    Invoke-UnitTest 'core-skill-remains-modular' {
        $lineCount = (Get-Content -LiteralPath $skillFile).Count
        Assert-True ($lineCount -lt 220) "SKILL.md is too large for a router: $lineCount lines"
        foreach ($reference in @('degree-profiles.md', 'lifecycle.md', 'proposal.md', 'experimental-design.md', 'writing-review.md', 'integrity.md')) {
            Assert-True ($skillText -match [regex]::Escape($reference)) "SKILL.md does not route to $reference"
        }
    }

    Invoke-UnitTest 'all-local-links-resolve' {
        $links = [regex]::Matches($skillText, '\]\((references/[^)]+|scripts/[^)]+|assets/[^)]+)\)')
        Assert-True ($links.Count -ge 8) 'Too few local links were found in SKILL.md'
        foreach ($link in $links) {
            $target = Join-Path $skillRootPath $link.Groups[1].Value
            Assert-True (Test-Path -LiteralPath $target -PathType Leaf) "Broken local link: $target"
        }
    }

    Invoke-UnitTest 'plugin-metadata-is-consistent' {
        $manifest = Get-Content -LiteralPath (Join-Path $pluginRoot '.codex-plugin\plugin.json') -Raw | ConvertFrom-Json
        Assert-Equal $manifest.name 'lab-research-kit' 'Unexpected plugin name'
        Assert-Equal $manifest.version '2.2.0' 'Unexpected plugin version'
        Assert-Equal $manifest.interface.displayName '学位科研副驾驶' 'Unexpected display name'
        $ui = Get-Content -LiteralPath (Join-Path $skillRootPath 'agents\openai.yaml') -Raw
        Assert-True ($ui -match '\$lab-research-router') 'openai.yaml default prompt does not invoke the skill'
    }

    Invoke-UnitTest 'bachelor-literature-is-lightweight-and-idempotent' {
        $path = Join-Path $testRoot 'bachelor-literature'
        $first = & $initializer -Path $path -Title '本科文献型项目' -Degree Bachelor -Track Literature -Discipline '中文'
        Assert-Equal $first.selected_count 19 'Bachelor Literature selected count is wrong'
        Assert-Equal $first.created_count 19 'Bachelor Literature created count is wrong'
        Assert-True (-not (Test-Path -LiteralPath (Join-Path $path 'research\04-experiments'))) 'Literature track should not create experiment files'
        $brief = Join-Path $path 'research\00-admin\research-brief.md'
        $beforeHash = (Get-FileHash -LiteralPath $brief -Algorithm SHA256).Hash
        $second = & $initializer -Path $path
        $afterHash = (Get-FileHash -LiteralPath $brief -Algorithm SHA256).Hash
        Assert-Equal $second.created_count 0 'Idempotent rerun created files'
        Assert-Equal $second.skipped_existing_count 19 'Idempotent rerun did not skip all files'
        Assert-Equal $afterHash $beforeHash 'Existing project file was overwritten'
        $briefText = Get-Content -LiteralPath $brief -Raw
        Assert-True ($briefText -match 'Degree: Bachelor') 'Bachelor degree was not recorded'
        Assert-True ($briefText -match 'Track: Literature') 'Literature track was not recorded'
    }

    Invoke-UnitTest 'master-wetlab-gets-design-files' {
        $path = Join-Path $testRoot 'master-wetlab'
        $result = & $initializer -Path $path -Title '硕士湿实验' -Degree Master -Track WetLab -Discipline '生物化学'
        Assert-Equal $result.selected_count 26 'Master WetLab selected count is wrong'
        foreach ($relative in @(
            'research\04-experiments\design-brief.md',
            'research\04-experiments\randomization.csv',
            'research\04-experiments\statistical-analysis-plan.md',
            'research\07-review\rebuttal.md'
        )) {
            Assert-True (Test-Path -LiteralPath (Join-Path $path $relative) -PathType Leaf) "Master WetLab missing $relative"
        }
    }

    Invoke-UnitTest 'doctoral-computational-gets-program-files' {
        $path = Join-Path $testRoot 'doctoral-computational'
        $result = & $initializer -Path $path -Title '博士计算项目' -Degree Doctoral -Track Computational -Discipline '计算机科学'
        Assert-Equal $result.selected_count 28 'Doctoral Computational selected count is wrong'
        Assert-True (Test-Path -LiteralPath (Join-Path $path 'research\00-admin\research-program.md') -PathType Leaf) 'Doctoral research program is missing'
        Assert-True (Test-Path -LiteralPath (Join-Path $path 'research\03-proposal\work-packages.md') -PathType Leaf) 'Doctoral work packages are missing'
    }

    Invoke-UnitTest 'engineering-and-design-do-not-get-wetlab-files' {
        foreach ($track in @('Engineering', 'Design')) {
            $path = Join-Path $testRoot $track.ToLowerInvariant()
            $result = & $initializer -Path $path -Title "$track 本科毕设" -Degree Bachelor -Track $track -Discipline '设计与工程'
            Assert-Equal $result.selected_count 22 "$track selected count is wrong"
            Assert-True (-not (Test-Path -LiteralPath (Join-Path $path 'research\04-experiments\randomization.csv'))) "$track should not receive wet-lab randomization"
            Assert-True (-not (Test-Path -LiteralPath (Join-Path $path 'research\04-experiments\statistical-analysis-plan.md'))) "$track should not receive a default statistical analysis plan"
        }
        Assert-True (Test-Path -LiteralPath (Join-Path $testRoot 'engineering\research\04-experiments\test-matrix.csv')) 'Engineering test matrix is missing'
        Assert-True (Test-Path -LiteralPath (Join-Path $testRoot 'design\research\04-experiments\evaluation-plan.md')) 'Design evaluation plan is missing'
    }

    Invoke-UnitTest 'whatif-is-read-only' {
        $path = Join-Path $testRoot 'whatif'
        & $initializer -Path $path -Title '只读测试' -Degree Bachelor -Track General -WhatIf *> $null
        Assert-True (-not (Test-Path -LiteralPath (Join-Path $path 'research'))) 'WhatIf created a research directory'
    }

    Invoke-UnitTest 'invalid-profile-is-rejected' {
        $threw = $false
        try {
            & $initializer -Path (Join-Path $testRoot 'invalid') -Degree 'HighSchool' -Track General -ErrorAction Stop | Out-Null
        } catch {
            $threw = $true
        }
        Assert-True $threw 'Invalid degree profile was accepted'
    }

    Invoke-UnitTest 'canonical-project-state-is-created' {
        $path = Join-Path $testRoot 'canonical-state'
        $result = & $initializer -Path $path -Title '状态测试' -Degree Master -Track Empirical -Discipline '教育学' -CurrentStage topic -Institution '示例大学' -ExpectedGraduation '2027-06'
        $state = Get-Content -LiteralPath $result.canonical_state -Raw | ConvertFrom-Json
        Assert-Equal $state.schema_version 1 'Unexpected state schema version'
        Assert-Equal $state.plugin_version '2.2.0' 'State has wrong plugin version'
        Assert-Equal $state.student.degree 'Master' 'Degree is missing from canonical state'
        Assert-Equal $state.project.track 'Empirical' 'Track is missing from canonical state'
        Assert-Equal $state.workflow.stage 'topic' 'Stage is missing from canonical state'
        Assert-True (-not [string]::IsNullOrWhiteSpace($state.project_id)) 'Project ID was not generated'
    }

    Invoke-UnitTest 'conflicting-reinitialization-is-rejected' {
        $path = Join-Path $testRoot 'conflicting-reinit'
        & $initializer -Path $path -Degree Master -Track Literature | Out-Null
        $threw = $false
        try { & $initializer -Path $path -Degree Bachelor -Track Literature -ErrorAction Stop | Out-Null } catch { $threw = $_.Exception.Message -match 'update-research-project.ps1' }
        Assert-True $threw 'Conflicting reinitialization was not rejected with migration guidance'
    }

    Invoke-UnitTest 'project-update-migrates-profile-and-adds-files' {
        $path = Join-Path $testRoot 'profile-migration'
        & $initializer -Path $path -Title '迁移测试' -Degree Bachelor -Track Literature -Discipline '管理学' | Out-Null
        $result = & $updater -Path $path -Degree Master -Track WetLab -Discipline '生物化学' -CurrentStage proposal
        $state = Get-Content -LiteralPath (Join-Path $path 'research\project.json') -Raw | ConvertFrom-Json
        Assert-True $result.changed 'Profile migration reported no change'
        Assert-True ($result.created_missing -ge 7) 'Profile migration did not add specialized files'
        Assert-Equal $state.student.degree 'Master' 'Degree migration failed'
        Assert-Equal $state.project.track 'WetLab' 'Track migration failed'
        Assert-True (Test-Path -LiteralPath (Join-Path $path 'research\04-experiments\statistical-analysis-plan.md')) 'Wet-lab analysis plan was not added'
        Assert-True (Test-Path -LiteralPath (Join-Path $path 'research\07-review\rebuttal.md')) 'Graduate rebuttal file was not added'
    }

    Invoke-UnitTest 'project-update-syncs-generated-headers' {
        $path = Join-Path $testRoot 'header-sync'
        & $initializer -Path $path -Degree Bachelor -Track Literature -Discipline '旧学科' | Out-Null
        & $updater -Path $path -Degree Master -Track Computational -Discipline '新学科' | Out-Null
        foreach ($relative in @('research\00-admin\research-brief.md', 'research\03-proposal\proposal-outline.md', 'research\04-experiments\design-brief.md', 'research\06-manuscript\manuscript.md')) {
            $text = Get-Content -LiteralPath (Join-Path $path $relative) -Raw
            Assert-True ($text -match '(?m)^- Degree: Master$') "$relative has a stale degree header"
            Assert-True ($text -match '(?m)^- Track: Computational$') "$relative has a stale track header"
            Assert-True ($text -match '(?m)^- Discipline: 新学科$') "$relative has a stale discipline header"
        }
    }

    Invoke-UnitTest 'project-update-appends-decision-log' {
        $path = Join-Path $testRoot 'decision-update'
        & $initializer -Path $path -Degree Master -Track Literature | Out-Null
        & $updater -Path $path -CurrentStage writing -CurrentBlocker '缺少图表' -NextGate '完成结果图' | Out-Null
        $log = Get-Content -LiteralPath (Join-Path $path 'research\00-admin\decision-log.md') -Raw
        Assert-True ($log -match 'Project profile update') 'Update was not recorded in the decision log'
        Assert-True ($log -match '缺少图表') 'Updated blocker was not recorded in the decision log'
    }

    Invoke-UnitTest 'research-status-reads-canonical-state' {
        $path = Join-Path $testRoot 'status-reader'
        & $initializer -Path $path -Title '状态恢复' -Degree Doctoral -Track Computational -CurrentStage analysis -ExpectedGraduation '2028-06' | Out-Null
        & $updater -Path $path -Health at-risk -CurrentBlocker '算力不足' -NextGate '完成基线实验' | Out-Null
        $status = & $statusReader -Path $path
        Assert-Equal $status.title '状态恢复' 'Status title is wrong'
        Assert-Equal $status.stage 'analysis' 'Status stage is wrong'
        Assert-Equal $status.health 'at-risk' 'Status health is wrong'
        Assert-Equal $status.current_blocker '算力不足' 'Status blocker is wrong'
        & $statusReader -Path $path -Write | Out-Null
        $view = Get-Content -LiteralPath (Join-Path $path 'research\00-admin\status.md') -Raw
        Assert-True ($view -match '完成基线实验') 'Generated status view is stale'
    }

    Invoke-UnitTest 'empty-stage-validation-fails' {
        $path = Join-Path $testRoot 'empty-gate'
        & $initializer -Path $path -Degree Master -Track WetLab -CurrentStage intake | Out-Null
        $global:LASTEXITCODE = 0
        & $stageValidator -Path $path -Stage intake -Json *> $null
        Assert-Equal $LASTEXITCODE 2 'Empty intake did not fail with exit code 2'
    }

    Invoke-UnitTest 'completed-intake-validation-passes' {
        $path = Join-Path $testRoot 'complete-intake'
        & $initializer -Path $path -Degree Bachelor -Track Literature | Out-Null
        $brief = Join-Path $path 'research\00-admin\research-brief.md'
        [System.IO.File]::WriteAllText($brief, "# Research brief`n研究问题：比较两种教学反馈方式对作业修订质量的影响。`n约束：十二周内完成，只使用获得许可的匿名课程数据。`n交付物：形成可复核的本科论文、分析记录和答辩材料。`n成功标准：问题边界、数据权限、分析方法和截止时间均得到导师确认。`n", (New-Object System.Text.UTF8Encoding($false)))
        $global:LASTEXITCODE = 0
        & $stageValidator -Path $path -Stage intake -Json *> $null
        Assert-Equal $LASTEXITCODE 0 'Completed intake did not pass'
    }

    Invoke-UnitTest 'filesystem-root-is-rejected' {
        $threw = $false
        try { & $initializer -Path ([System.IO.Path]::GetPathRoot($testRoot)) -Degree Bachelor -Track Literature -ErrorAction Stop | Out-Null } catch { $threw = $_.Exception.Message -match 'filesystem root' }
        Assert-True $threw 'Filesystem-root initialization was accepted'
    }

    Invoke-UnitTest 'multiline-metadata-is-rejected' {
        $threw = $false
        try { & $initializer -Path (Join-Path $testRoot 'multiline') -Title "line1`nline2" -Degree Bachelor -Track Literature -ErrorAction Stop | Out-Null } catch { $threw = $_.Exception.Message -match 'single-line' }
        Assert-True $threw 'Multiline metadata was accepted'
    }

    Invoke-UnitTest 'update-with-no-fields-is-rejected' {
        $path = Join-Path $testRoot 'empty-update'
        & $initializer -Path $path -Degree Bachelor -Track General | Out-Null
        $threw = $false
        try { & $updater -Path $path -ErrorAction Stop | Out-Null } catch { $threw = $_.Exception.Message -match 'No project fields' }
        Assert-True $threw 'Empty project update was accepted'
    }

    Invoke-UnitTest 'historical-track-files-are-retained' {
        $path = Join-Path $testRoot 'historical-files'
        & $initializer -Path $path -Degree Bachelor -Track Engineering | Out-Null
        $engineeringFile = Join-Path $path 'research\04-experiments\test-matrix.csv'
        Assert-True (Test-Path -LiteralPath $engineeringFile) 'Engineering file was not initialized'
        & $updater -Path $path -Track Literature | Out-Null
        Assert-True (Test-Path -LiteralPath $engineeringFile) 'Historical track file was silently deleted'
    }

    Invoke-UnitTest 'quality-contract-cases-have-source-coverage' {
        $cases = Get-Content -LiteralPath $caseFile -Raw | ConvertFrom-Json
        Assert-True ($cases.Count -ge 8) 'Too few quality contract cases'
        foreach ($case in $cases) {
            $referencePath = Join-Path $skillRootPath $case.expected_reference
            Assert-True (Test-Path -LiteralPath $referencePath -PathType Leaf) "Case $($case.id) points to a missing reference"
            $referenceText = Get-Content -LiteralPath $referencePath -Raw
            foreach ($term in $case.required_terms) {
                Assert-True ($referenceText.IndexOf($term, [System.StringComparison]::OrdinalIgnoreCase) -ge 0) "Case $($case.id) lacks contract term: $term"
            }
            Assert-True ($case.expected_stage -in @('intake', 'topic', 'proposal', 'experiment', 'execution', 'analysis', 'writing', 'review', 'defense', 'audit')) "Case $($case.id) has an invalid stage"
        }
    }
} finally {
    $resolvedTestRoot = [System.IO.Path]::GetFullPath($testRoot)
    $leaf = Split-Path -Leaf $resolvedTestRoot
    $insideTemp = $resolvedTestRoot.StartsWith($tempBase, [System.StringComparison]::OrdinalIgnoreCase)
    if ($insideTemp -and $leaf.StartsWith('lab-research-router-tests-', [System.StringComparison]::OrdinalIgnoreCase) -and (Test-Path -LiteralPath $resolvedTestRoot)) {
        Remove-Item -LiteralPath $resolvedTestRoot -Recurse -Force
    }
}

$passed = @($results | Where-Object { $_.status -eq 'passed' }).Count
$failed = @($results | Where-Object { $_.status -eq 'failed' }).Count
$score = if ($results.Count -gt 0) { [math]::Round(100 * $passed / $results.Count, 1) } else { 0 }
$resultArray = $results.ToArray()
$summary = [pscustomobject]@{
    suite = 'lab-research-router-quality'
    checked_at = (Get-Date).ToString('o')
    total = $results.Count
    passed = $passed
    failed = $failed
    score_percent = $score
    tests = $resultArray
}

$summary | ConvertTo-Json -Depth 6
if ($failed -gt 0) { exit 1 }
