# Generate index files for rust-skills
# Run this to rebuild indexes after making changes

$ErrorActionPreference = "Stop"

$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$ROOT_DIR = Split-Path -Parent $SCRIPT_DIR
$INDEX_DIR = Join-Path $ROOT_DIR "index"

New-Item -ItemType Directory -Force -Path $INDEX_DIR | Out-Null

Write-Host "Generating rust-skills indexes..."

# =====================================
# Generate skills-index.md
# =====================================
$skills_index = @"
# Skills Index

Auto-generated index of all rust-skills.

## Meta-Question Skills (m01-m15)

| ID | Name | Core Question |
|----|------|---------------|
"@

Get-ChildItem -Path "$ROOT_DIR\skills" -Directory | Where-Object { $_.Name -match "^m[0-9]" } | Sort-Object Name | ForEach-Object {
    $skill_file = Join-Path $_.FullName "SKILL.md"
    if (Test-Path $skill_file) {
        $skill_name = $_.Name
        $content = Get-Content $skill_file -Raw

        # Extract title
        $title_match = [regex]::Match($content, "(?m)^# (.+)$")
        $title = if ($title_match.Success) { $title_match.Groups[1].Value } else { "" }

        # Extract core question
        $core_q_match = [regex]::Match($content, 'Core Question: "([^"]+)"')
        $core_q = if ($core_q_match.Success) { $core_q_match.Groups[1].Value } else { "" }

        $skills_index += "`n| $skill_name | $title | $core_q |"
    }
}

$skills_index += @"

## Core Skills

| Name | Description |
|------|-------------|
"@

Get-ChildItem -Path "$ROOT_DIR\skills" -Directory | Where-Object { $_.Name -match "^core-" } | ForEach-Object {
    $skill_file = Join-Path $_.FullName "SKILL.md"
    if (Test-Path $skill_file) {
        $skill_name = $_.Name
        $content = Get-Content $skill_file -Raw
        $desc_match = [regex]::Match($content, "(?ms)^description:\s*(.+?)(?=^[a-z]+:|$)")
        $desc = if ($desc_match.Success) { $desc_match.Groups[1].Value.Trim().Substring(0, [Math]::Min(60, $desc_match.Groups[1].Value.Trim().Length)) } else { "" }
        $skills_index += "`n| $skill_name | $desc... |"
    }
}

$skills_index += @"

## Specialized Skills

| Name | Description |
|------|-------------|
"@

@("unsafe-checker", "coding-guidelines") | ForEach-Object {
    $skill_file = Join-Path "$ROOT_DIR\skills\$_" "SKILL.md"
    if (Test-Path $skill_file) {
        $skill_name = $_
        $content = Get-Content $skill_file -Raw
        $desc_match = [regex]::Match($content, "(?ms)^description:\s*(.+?)(?=^[a-z]+:|$)")
        $desc = if ($desc_match.Success) { $desc_match.Groups[1].Value.Trim().Substring(0, [Math]::Min(60, $desc_match.Groups[1].Value.Trim().Length)) } else { "" }
        $skills_index += "`n| $skill_name | $desc... |"
    }
}

$skills_index += @"

## Domain Skills

| Name | Focus Area |
|------|------------|
"@

Get-ChildItem -Path "$ROOT_DIR\skills" -Directory | Where-Object { $_.Name -match "^domain-" } | ForEach-Object {
    $skill_file = Join-Path $_.FullName "SKILL.md"
    if (Test-Path $skill_file) {
        $skill_name = $_.Name
        $content = Get-Content $skill_file -Raw
        $title_match = [regex]::Match($content, "(?m)^# (.+)$")
        $title = if ($title_match.Success) { $title_match.Groups[1].Value } else { "" }
        $skills_index += "`n| $skill_name | $title |"
    }
}

Set-Content -Path (Join-Path $INDEX_DIR "skills-index.md") -Value $skills_index
Write-Host "Generated: index/skills-index.md"

# =====================================
# Generate agents-index.md
# =====================================
$agents_index = @"
# Agents Index

Auto-generated index of all agents.

| Agent | Model | Tools | Purpose |
|-------|-------|-------|---------|
"@

Get-ChildItem -Path "$ROOT_DIR\agents" -Filter "*.md" -File | ForEach-Object {
    $agent_name = $_.BaseName
    $content = Get-Content $_.FullName -Raw

    $model_match = [regex]::Match($content, "(?m)^model:\s*(.+)$")
    $model = if ($model_match.Success) { $model_match.Groups[1].Value.Trim() } else { "haiku" }

    $tools = ([regex]::Matches($content, "(?m)^  -")).Count

    $desc_match = [regex]::Match($content, "(?m)^# (.+)$")
    $desc = if ($desc_match.Success) { $desc_match.Groups[1].Value.Substring(0, [Math]::Min(40, $desc_match.Groups[1].Value.Length)) } else { "Background agent" }

    $agents_index += "`n| $agent_name | $model | $tools | $desc |"
}

Set-Content -Path (Join-Path $INDEX_DIR "agents-index.md") -Value $agents_index
Write-Host "Generated: index/agents-index.md"

# =====================================
# Generate triggers-index.md
# =====================================
$triggers_index = @"
# Trigger Keywords Index

Keywords that trigger each skill.

"@

Get-ChildItem -Path "$ROOT_DIR\skills" -Directory | Where-Object { $_.Name -match "^m[0-9]" } | Sort-Object Name | ForEach-Object {
    $skill_file = Join-Path $_.FullName "SKILL.md"
    if (Test-Path $skill_file) {
        $skill_name = $_.Name
        $triggers_index += "`n## $skill_name`n`n"

        $content = Get-Content $skill_file -Raw
        $desc_match = [regex]::Match($content, "(?ms)^description:(.+?)(?=^[a-z]+:|$)")
        if ($desc_match.Success) {
            $desc_lines = $desc_match.Groups[1].Value.Trim() -split "`n" | Select-Object -First 5
            $triggers_index += ($desc_lines -join "`n") + "`n"
        }
    }
}

Set-Content -Path (Join-Path $INDEX_DIR "triggers-index.md") -Value $triggers_index
Write-Host "Generated: index/triggers-index.md"

# =====================================
# Generate commands-index.md
# =====================================
$commands_index = @"
# Commands Index

Available slash commands.

| Command | Usage | Description |
|---------|-------|-------------|
"@

Get-ChildItem -Path "$ROOT_DIR\commands" -Filter "*.md" -File | ForEach-Object {
    $cmd_name = $_.BaseName
    $content = Get-Content $_.FullName -Raw

    # Extract usage
    $usage_match = [regex]::Match($content, "(?ms)## Usage.+?```(.+?)```")
    $usage = if ($usage_match.Success) { $usage_match.Groups[1].Value.Trim() } else { "" }

    # Extract description
    $desc_match = [regex]::Match($content, "(?m)^[A-Z].+$")
    $desc = if ($desc_match.Success) { $desc_match.Value.Substring(0, [Math]::Min(40, $desc_match.Value.Length)) } else { "" }

    $commands_index += "`n| /$cmd_name | ``$usage`` | $desc... |"
}

Set-Content -Path (Join-Path $INDEX_DIR "commands-index.md") -Value $commands_index
Write-Host "Generated: index/commands-index.md"

# =====================================
# Summary
# =====================================
Write-Host ""
Write-Host "Index generation complete!"
Write-Host "Generated files:"
Get-ChildItem -Path $INDEX_DIR -Filter "*.md" | ForEach-Object {
    Write-Host "  - $($_.Name)"
}
