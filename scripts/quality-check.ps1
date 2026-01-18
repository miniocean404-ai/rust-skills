# Quality check script for rust-skills
# Run before releases to ensure consistency

$ErrorActionPreference = "Stop"

$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$ROOT_DIR = Split-Path -Parent $SCRIPT_DIR

Write-Host "======================================"
Write-Host "Rust Skills Quality Check"
Write-Host "======================================"
Write-Host ""

$ERRORS = 0
$WARNINGS = 0

function Write-Error-Message {
    param([string]$Message)
    Write-Host "ERROR: $Message" -ForegroundColor Red
    $script:ERRORS++
}

function Write-Warning-Message {
    param([string]$Message)
    Write-Host "WARN: $Message" -ForegroundColor Yellow
    $script:WARNINGS++
}

function Write-Pass-Message {
    param([string]$Message)
    Write-Host "OK: $Message" -ForegroundColor Green
}

# =====================================
# 1. Check SKILL.md Frontmatter
# =====================================
Write-Host "Checking SKILL.md frontmatter..."

Get-ChildItem -Path "$ROOT_DIR\skills" -Filter "SKILL.md" -Recurse -File | ForEach-Object {
    $skill_name = Split-Path -Leaf (Split-Path -Parent $_.FullName)
    $content = Get-Content $_.FullName -Raw

    # Check for required fields
    if ($content -notmatch "(?m)^name:") {
        Write-Error-Message "$skill_name/SKILL.md missing 'name:' field"
    }

    if ($content -notmatch "(?m)^description:") {
        Write-Error-Message "$skill_name/SKILL.md missing 'description:' field"
    }

    # Check description has trigger words
    $desc_match = [regex]::Match($content, "(?ms)^description:.*?(?=^[a-z]+:|$)")
    if ($desc_match.Success -and $desc_match.Value.Length -lt 50) {
        Write-Warning-Message "$skill_name/SKILL.md description may be too short for triggering"
    }
}

Write-Host ""

# =====================================
# 2. Check Agent Tool Declarations
# =====================================
Write-Host "Checking agent tool declarations..."

Get-ChildItem -Path "$ROOT_DIR\agents" -Filter "*.md" -File | ForEach-Object {
    $agent_name = $_.BaseName
    $content = Get-Content $_.FullName -Raw

    if ($content -notmatch "(?m)^tools:") {
        Write-Error-Message "$agent_name agent missing 'tools:' declaration"
    }

    if ($content -notmatch "(?m)^model:") {
        Write-Warning-Message "$agent_name agent missing 'model:' declaration"
    }
}

Write-Host ""

# =====================================
# 3. Check for Dead Links in Skills
# =====================================
Write-Host "Checking for dead internal links..."

Get-ChildItem -Path "$ROOT_DIR\skills" -Filter "*.md" -Recurse -File | ForEach-Object {
    $md_file = $_.FullName
    $content = Get-Content $md_file -Raw

    # Extract markdown links
    $links = [regex]::Matches($content, '\[.*?\]\(([^)]+)\)') | ForEach-Object { $_.Groups[1].Value }

    foreach ($link in $links) {
        # Skip external links and anchors
        if ($link -match "^http" -or $link -match "^#") {
            continue
        }

        # Resolve relative path
        $dir = Split-Path -Parent $md_file
        $full_path = Join-Path $dir $link

        if (-not (Test-Path $full_path)) {
            Write-Warning-Message "Dead link in $(Split-Path -Leaf $md_file): $link"
        }
    }
}

Write-Host ""

# =====================================
# 4. Check Version Consistency
# =====================================
Write-Host "Checking version consistency..."

$version_file = Join-Path $ROOT_DIR "VERSION"
$metadata_file = Join-Path $ROOT_DIR "metadata.json"

if ((Test-Path $version_file) -and (Test-Path $metadata_file)) {
    $version = (Get-Content $version_file -Raw).Trim()
    $metadata_content = Get-Content $metadata_file -Raw | ConvertFrom-Json
    $metadata_version = $metadata_content.version

    if ($version -ne $metadata_version) {
        Write-Error-Message "Version mismatch: VERSION=$version, metadata.json=$metadata_version"
    } else {
        Write-Pass-Message "Version consistent: $version"
    }
} else {
    Write-Warning-Message "Missing VERSION or metadata.json"
}

Write-Host ""

# =====================================
# 5. Check Required Directories
# =====================================
Write-Host "Checking required directories..."

$required_dirs = @(
    "skills",
    "agents",
    "commands",
    "cache",
    "tests",
    "templates"
)

foreach ($dir in $required_dirs) {
    $dir_path = Join-Path $ROOT_DIR $dir
    if (Test-Path $dir_path) {
        $count = (Get-ChildItem -Path $dir_path -Recurse -File).Count
        Write-Pass-Message "$dir/ exists ($count files)"
    } else {
        Write-Error-Message "$dir/ missing"
    }
}

Write-Host ""

# =====================================
# 6. Check Skill Count Matches Metadata
# =====================================
Write-Host "Checking skill counts..."

if (Test-Path $metadata_file) {
    $metadata_content = Get-Content $metadata_file -Raw | ConvertFrom-Json
    $expected_meta = $metadata_content.meta_skills
    $actual_meta = (Get-ChildItem -Path "$ROOT_DIR\skills" -Directory | Where-Object { $_.Name -match "^m[0-9]" }).Count

    if ($expected_meta -eq $actual_meta) {
        Write-Pass-Message "Meta skills count: $actual_meta"
    } else {
        Write-Warning-Message "Meta skills: expected $expected_meta, found $actual_meta"
    }

    $expected_unsafe = $metadata_content.unsafe_rules
    $unsafe_rules_path = Join-Path $ROOT_DIR "skills\unsafe-checker\rules"
    if (Test-Path $unsafe_rules_path) {
        $actual_unsafe = (Get-ChildItem -Path $unsafe_rules_path -Filter "*.md" -File | Where-Object { $_.Name -notmatch "^_" }).Count

        if ($expected_unsafe -eq $actual_unsafe) {
            Write-Pass-Message "Unsafe rules count: $actual_unsafe"
        } else {
            Write-Warning-Message "Unsafe rules: expected $expected_unsafe, found $actual_unsafe"
        }
    }
}

Write-Host ""

# =====================================
# Summary
# =====================================
Write-Host "======================================"
Write-Host "Quality Check Summary"
Write-Host "======================================"
Write-Host "Errors:   $ERRORS" -ForegroundColor $(if ($ERRORS -gt 0) { "Red" } else { "White" })
Write-Host "Warnings: $WARNINGS" -ForegroundColor $(if ($WARNINGS -gt 0) { "Yellow" } else { "White" })
Write-Host ""

if ($ERRORS -gt 0) {
    Write-Host "Quality check FAILED" -ForegroundColor Red
    exit 1
} elseif ($WARNINGS -gt 0) {
    Write-Host "Quality check PASSED with warnings" -ForegroundColor Yellow
    exit 0
} else {
    Write-Host "Quality check PASSED" -ForegroundColor Green
    exit 0
}
