# Analyze rust-skills structure and content
# Provides statistics and insights

$ErrorActionPreference = "Stop"

$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$ROOT_DIR = Split-Path -Parent $SCRIPT_DIR

Write-Host "======================================"
Write-Host "Rust Skills Analysis"
Write-Host "======================================"
Write-Host ""

# =====================================
# Skill Statistics
# =====================================
Write-Host "## Skill Statistics"
Write-Host ""

$meta_count = (Get-ChildItem -Path "$ROOT_DIR\skills" -Directory | Where-Object { $_.Name -match "^m[0-9]" }).Count
Write-Host "Meta-Question Skills: $meta_count"

$core_path = Join-Path $ROOT_DIR "skills\core"
if (Test-Path $core_path) {
    $core_count = (Get-ChildItem -Path $core_path -Directory).Count
    Write-Host "Core Skills: $core_count"
}

$domain_path = Join-Path $ROOT_DIR "skills\domains"
if (Test-Path $domain_path) {
    $domain_count = (Get-ChildItem -Path $domain_path -Directory).Count
    Write-Host "Domain Skills: $domain_count"
}

Write-Host ""

# =====================================
# Content Statistics
# =====================================
Write-Host "## Content Statistics"
Write-Host ""

# Count markdown files
$md_count = (Get-ChildItem -Path $ROOT_DIR -Filter "*.md" -Recurse -File).Count
Write-Host "Total Markdown Files: $md_count"

# Count lines of content
$total_lines = 0
Get-ChildItem -Path $ROOT_DIR -Filter "*.md" -Recurse -File | ForEach-Object {
    $total_lines += (Get-Content $_.FullName).Count
}
Write-Host "Total Lines of Content: $total_lines"

# Unsafe rules
$unsafe_rules_path = Join-Path $ROOT_DIR "skills\unsafe-checker\rules"
if (Test-Path $unsafe_rules_path) {
    $unsafe_rules = (Get-ChildItem -Path $unsafe_rules_path -Filter "*.md" -File | Where-Object { $_.Name -notmatch "^_" }).Count
    Write-Host "Unsafe Checker Rules: $unsafe_rules"
}

# Templates
$templates_path = Join-Path $ROOT_DIR "templates"
if (Test-Path $templates_path) {
    $template_count = (Get-ChildItem -Path $templates_path -Filter "*.rs" -Recurse -File).Count
    Write-Host "Code Templates: $template_count"
}

Write-Host ""

# =====================================
# Agent Statistics
# =====================================
Write-Host "## Agent Statistics"
Write-Host ""

$agent_count = (Get-ChildItem -Path "$ROOT_DIR\agents" -Filter "*.md" -File).Count
Write-Host "Total Agents: $agent_count"

Write-Host "Agents:"
Get-ChildItem -Path "$ROOT_DIR\agents" -Filter "*.md" -File | ForEach-Object {
    $name = $_.BaseName
    $content = Get-Content $_.FullName -Raw
    $model_match = [regex]::Match($content, "(?m)^model:\s*(.+)$")
    $model = if ($model_match.Success) { $model_match.Groups[1].Value.Trim() } else { "default" }
    Write-Host "  - $name ($model)"
}

Write-Host ""

# =====================================
# Deep Dive Content
# =====================================
Write-Host "## Deep Dive Content"
Write-Host ""

Write-Host "Skills with patterns/ directory:"
Get-ChildItem -Path "$ROOT_DIR\skills" -Directory | Where-Object { $_.Name -match "^m" } | ForEach-Object {
    $patterns_path = Join-Path $_.FullName "patterns"
    if (Test-Path $patterns_path) {
        $skill_name = $_.Name
        $pattern_count = (Get-ChildItem -Path $patterns_path -Filter "*.md" -File).Count
        Write-Host "  - $skill_name: $pattern_count files"
    }
}

Write-Host ""
Write-Host "Skills with examples/ directory:"
Get-ChildItem -Path "$ROOT_DIR\skills" -Directory | Where-Object { $_.Name -match "^m" } | ForEach-Object {
    $examples_path = Join-Path $_.FullName "examples"
    if (Test-Path $examples_path) {
        $skill_name = $_.Name
        $example_count = (Get-ChildItem -Path $examples_path -Filter "*.md" -File).Count
        Write-Host "  - $skill_name: $example_count files"
    }
}

Write-Host ""

# =====================================
# Trigger Coverage
# =====================================
Write-Host "## Trigger Coverage Analysis"
Write-Host ""

Write-Host "Extracting trigger keywords..."
$keywords = ""
Get-ChildItem -Path "$ROOT_DIR\skills" -Filter "SKILL.md" -Recurse -File | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    $desc_match = [regex]::Match($content, "(?ms)^description:.*?(?=^[a-z]+:|$)")
    if ($desc_match.Success) {
        $keywords += " " + $desc_match.Value
    }
}

Write-Host "Top trigger categories:"
$error_codes = [regex]::Matches($keywords, "E[0-9]{4}") | ForEach-Object { $_.Value } | Sort-Object -Unique
Write-Host "  - Error codes (E0xxx): $($error_codes.Count) unique"
Write-Host "  - Crate names: Multiple (tokio, serde, axum, etc.)"

Write-Host ""

# =====================================
# Test Coverage
# =====================================
Write-Host "## Test Coverage"
Write-Host ""

$scenarios_path = Join-Path $ROOT_DIR "tests\scenarios"
if (Test-Path $scenarios_path) {
    $scenario_count = (Get-ChildItem -Path $scenarios_path -Filter "*.md" -File).Count
    Write-Host "Test Scenario Files: $scenario_count"

    $total_tests = 0
    Get-ChildItem -Path $scenarios_path -Filter "*.md" -File | ForEach-Object {
        $content = Get-Content $_.FullName -Raw
        $test_count = ([regex]::Matches($content, "(?m)^### Test")).Count
        $total_tests += $test_count
    }
    Write-Host "Total Test Cases: $total_tests"
} else {
    Write-Host "No test scenarios found"
}

Write-Host ""

# =====================================
# Cache Status
# =====================================
Write-Host "## Cache Status"
Write-Host ""

$cache_path = Join-Path $ROOT_DIR "cache"
if (Test-Path $cache_path) {
    Write-Host "Cache directories:"
    Get-ChildItem -Path $cache_path -Directory | ForEach-Object {
        $dir_name = $_.Name
        $file_count = (Get-ChildItem -Path $_.FullName -Recurse -File).Count
        Write-Host "  - $dir_name: $file_count entries"
    }
} else {
    Write-Host "Cache not initialized"
}

Write-Host ""

# =====================================
# Summary
# =====================================
Write-Host "======================================"
Write-Host "Summary"
Write-Host "======================================"
Write-Host ""
Write-Host "Total Agents: $agent_count"
Write-Host "Total Content: $md_count files, $total_lines lines"
Write-Host ""
