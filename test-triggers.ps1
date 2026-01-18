# Rust Skills Trigger Test Script
# Tests if the Forced Eval Hook is working
#
# Usage:
#   .\test-triggers.ps1              # Run all tests
#   .\test-triggers.ps1 -Verbose     # Verbose mode (show full output)
#   .\test-triggers.ps1 "query"      # Test single query
#   .\test-triggers.ps1 -Verbose "query"   # Single query with verbose

param(
    [switch]$Verbose,
    [string]$SingleTest = ""
)

$ErrorActionPreference = "Stop"

Write-Host "=== Rust Skills Forced Eval Hook Tests ==="
Write-Host ""
Write-Host "Testing if hook triggers and Claude evaluates skills..."
Write-Host ""

# Test counter
$PASS = 0
$FAIL = 0

# Test function - checks if response contains skill evaluation
function Test-Hook {
    param(
        [string]$Query,
        [string]$ExpectedSkill
    )

    Write-Host -NoNewline "Testing: `"$Query`" "
    Write-Host -NoNewline "→ expecting evaluation of $ExpectedSkill ... "

    # Run claude and capture output (first 50 lines)
    try {
        $result = claude -p $Query 2>&1 | Select-Object -First 50 | Out-String
    } catch {
        $result = ""
    }

    # Check if output contains skill evaluation pattern
    # Patterns: "[RUST-SKILL-EVAL]", "YES -", "NO -", skill names, etc.
    if ($result -match "\[RUST-SKILL-EVAL\]|(YES|NO)[ :-]|Skill\(|skill.*:|m0[1-7]-|unsafe-checker|coding-guidelines|rust-learner|rust-router|domain-") {
        Write-Host "HOOK TRIGGERED" -ForegroundColor Green

        # Check if the expected skill was mentioned
        if ($result -match $ExpectedSkill) {
            Write-Host "  └─ ✓ $ExpectedSkill evaluated" -ForegroundColor Green
            $script:PASS++
        } else {
            Write-Host "  └─ ? $ExpectedSkill not explicitly mentioned" -ForegroundColor Yellow
            $script:PASS++  # Hook still worked
        }
    } else {
        Write-Host "HOOK NOT TRIGGERED" -ForegroundColor Red
        Write-Host "  First 300 chars of response:"
        Write-Host $result.Substring(0, [Math]::Min(300, $result.Length))
        Write-Host ""
        $script:FAIL++
    }

    # Show full output in verbose mode
    if ($Verbose) {
        Write-Host "  --- Full output ---"
        Write-Host $result
        Write-Host "  -------------------"
    }
    Write-Host ""
}

Write-Host "--- Testing Hook Activation ---"
Write-Host ""

# If single test specified, run only that
if ($SingleTest) {
    Test-Hook -Query $SingleTest -ExpectedSkill "any-skill"
} else {
    Test-Hook -Query "E0382 错误怎么解决" -ExpectedSkill "m01-ownership"
    Test-Hook -Query "Arc 和 Rc 什么区别" -ExpectedSkill "m02-resource"
    Test-Hook -Query "async await 怎么用" -ExpectedSkill "m07-concurrency"
    Test-Hook -Query "unsafe 代码怎么写安全" -ExpectedSkill "unsafe-checker"
}

Write-Host "=== Summary ==="
Write-Host "Hook Triggered: $PASS" -ForegroundColor Green
Write-Host "Hook Failed: $FAIL" -ForegroundColor Red
Write-Host ""

if ($FAIL -gt 0) {
    Write-Host "Some hooks didn't trigger. Check:" -ForegroundColor Yellow
    Write-Host "  1. Is this a new Claude session? (restart if needed)"
    Write-Host "  2. Is .claude/settings.local.json configured?"
    Write-Host "  3. Is .claude/hooks/rust-skill-eval-hook.sh executable?"
    exit 1
} else {
    Write-Host "All hooks triggered successfully!" -ForegroundColor Green
    exit 0
}
