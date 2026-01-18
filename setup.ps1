# Rust Skills Setup Script

Write-Host "Setting up Rust Skills for Claude Code..."

# Create permissions file if it doesn't exist
$settings_file = ".claude\settings.local.json"
if (-not (Test-Path $settings_file)) {
    New-Item -ItemType Directory -Force -Path ".claude" | Out-Null

    $settings = @{
        permissions = @{
            allow = @(
                "Bash(agent-browser *)"
            )
        }
    } | ConvertTo-Json -Depth 10

    Set-Content -Path $settings_file -Value $settings
    Write-Host "Created .claude/settings.local.json with agent-browser permissions"
} else {
    Write-Host ".claude/settings.local.json already exists, please add permissions manually:"
    Write-Host '  "Bash(agent-browser *)"'
}

Write-Host "Setup complete!"
Write-Host ""
Write-Host "Usage:"
Write-Host "  claude --plugin-dir $PSScriptRoot"
