# Rust Skills Validation Script
# Run this to validate skills are properly configured

$ErrorActionPreference = "Stop"

$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$ROOT_DIR = Split-Path -Parent (Split-Path -Parent $SCRIPT_DIR)

Write-Host "======================================"
Write-Host "Rust Skills Validation"
Write-Host "======================================"
Write-Host ""

$FAILED = 0

function Write-Pass {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Fail {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
    $script:FAILED = 1
}

function Write-Warn {
    param([string]$Message)
    Write-Host "! $Message" -ForegroundColor Yellow
}

# =====================================
# Directory Structure Check
# =====================================
Write-Host "Checking directory structure..."

$dirs = @(
    "skills\m01-ownership",
    "skills\m06-error-handling",
    "skills\m07-concurrency",
    "skills\m10-performance",
    "skills\m14-mental-model",
    "skills\m15-anti-pattern",
    "skills\unsafe-checker",
    "skills\coding-guidelines",
    "skills\rust-router",
    "skills\rust-learner",
    "agents",
    "commands",
    "cache",
    "tests"
)

foreach ($dir in $dirs) {
    $dir_path = Join-Path $ROOT_DIR $dir
    if (Test-Path $dir_path) {
        Write-Pass "$dir exists"
    } else {
        Write-Fail "$dir missing"
    }
}

Write-Host ""

# =====================================
# SKILL.md Files Check
# =====================================
Write-Host "Checking SKILL.md files..."

$skill_files = @(
    "skills\m01-ownership\SKILL.md",
    "skills\m06-error-handling\SKILL.md",
    "skills\m07-concurrency\SKILL.md",
    "skills\unsafe-checker\SKILL.md",
    "skills\coding-guidelines\SKILL.md",
    "skills\rust-router\SKILL.md",
    "skills\rust-learner\SKILL.md"
)

foreach ($file in $skill_files) {
    $file_path = Join-Path $ROOT_DIR $file
    if (Test-Path $file_path) {
        # Check for required frontmatter
        $content = Get-Content $file_path -Raw
        if (($content -match "(?m)^name:") -and ($content -match "(?m)^description:")) {
            Write-Pass "$file valid"
        } else {
            Write-Fail "$file missing frontmatter"
        }
    } else {
        Write-Fail "$file missing"
    }
}

Write-Host ""

# =====================================
# Agent Files Check
# =====================================
Write-Host "Checking agent files..."

$agent_files = @(
    "agents\crate-researcher.md",
    "agents\rust-changelog.md",
    "agents\docs-researcher.md",
    "agents\clippy-researcher.md"
)

foreach ($file in $agent_files) {
    $file_path = Join-Path $ROOT_DIR $file
    if (Test-Path $file_path) {
        $content = Get-Content $file_path -Raw
        if ($content -match "(?m)^tools:") {
            Write-Pass "$file valid"
        } else {
            Write-Fail "$file missing tools section"
        }
    } else {
        Write-Fail "$file missing"
    }
}

Write-Host ""

# =====================================
# Command Files Check
# =====================================
Write-Host "Checking command files..."

$command_files = @(
    "commands\guideline.md",
    "commands\unsafe-check.md",
    "commands\unsafe-review.md"
)

foreach ($file in $command_files) {
    $file_path = Join-Path $ROOT_DIR $file
    if (Test-Path $file_path) {
        Write-Pass "$file exists"
    } else {
        Write-Fail "$file missing"
    }
}

Write-Host ""

# =====================================
# Unsafe-Checker Rules Check
# =====================================
Write-Host "Checking unsafe-checker rules..."

$rules_path = Join-Path $ROOT_DIR "skills\unsafe-checker\rules"
if (Test-Path $rules_path) {
    $rule_count = (Get-ChildItem -Path $rules_path -Filter "*.md" -File | Where-Object { $_.Name -notmatch "^_" }).Count
    if ($rule_count -ge 40) {
        Write-Pass "unsafe-checker has $rule_count rules (expected 40+)"
    } else {
        Write-Warn "unsafe-checker has $rule_count rules (expected 40+)"
    }
} else {
    Write-Fail "unsafe-checker rules directory missing"
}

# Check checklists
$checklists_path = Join-Path $ROOT_DIR "skills\unsafe-checker\checklists"
if (Test-Path $checklists_path) {
    $checklist_count = (Get-ChildItem -Path $checklists_path -Filter "*.md" -File).Count
    if ($checklist_count -ge 2) {
        Write-Pass "unsafe-checker has $checklist_count checklists"
    } else {
        Write-Warn "unsafe-checker has few checklists"
    }
} else {
    Write-Fail "unsafe-checker checklists missing"
}

Write-Host ""

# =====================================
# Deep Dive Content Check
# =====================================
Write-Host "Checking deep dive content..."

$deep_content = @(
    "skills\m01-ownership\patterns\common-errors.md",
    "skills\m01-ownership\patterns\lifetime-patterns.md",
    "skills\m01-ownership\comparison.md",
    "skills\m07-concurrency\patterns\common-errors.md",
    "skills\m07-concurrency\patterns\async-patterns.md",
    "skills\m10-performance\patterns\optimization-guide.md",
    "skills\m14-mental-model\patterns\thinking-in-rust.md",
    "skills\m15-anti-pattern\patterns\common-mistakes.md"
)

foreach ($file in $deep_content) {
    $file_path = Join-Path $ROOT_DIR $file
    if (Test-Path $file_path) {
        Write-Pass "$file exists"
    } else {
        Write-Warn "$file missing (deep dive content)"
    }
}

Write-Host ""

# =====================================
# Cache Structure Check
# =====================================
Write-Host "Checking cache structure..."

$cache_config = Join-Path $ROOT_DIR "cache\config.yaml"
if (Test-Path $cache_config) {
    Write-Pass "cache\config.yaml exists"
} else {
    Write-Warn "cache\config.yaml missing"
}

$cache_dirs = @("crates", "rust-versions", "clippy-lints", "docs")
foreach ($dir in $cache_dirs) {
    $cache_dir = Join-Path $ROOT_DIR "cache\$dir"
    if (Test-Path $cache_dir) {
        Write-Pass "cache\$dir exists"
    } else {
        Write-Warn "cache\$dir missing"
    }
}

Write-Host ""

# =====================================
# Summary
# =====================================
Write-Host "======================================"
if ($FAILED -eq 0) {
    Write-Host "All checks passed!" -ForegroundColor Green
} else {
    Write-Host "Some checks failed." -ForegroundColor Red
}
Write-Host "======================================"

exit $FAILED
