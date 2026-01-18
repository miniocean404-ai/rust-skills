# Rust Skills Tests

## Overview

This directory contains test scenarios for validating rust-skills functionality.

## Directory Structure

```
tests/
├── README.md
├── scenarios/           # Test scenarios by category
│   ├── ownership.md     # m01 ownership tests
│   ├── error-handling.md # m06 error handling tests
│   ├── concurrency.md   # m07 concurrency tests
│   ├── unsafe.md        # unsafe-checker tests
│   ├── routing.md       # rust-router tests
│   └── agents.md        # Agent integration tests
│
└── validation/          # Validation scripts
    ├── validate-skills.sh
    └── validate-skills.ps1  # Windows version
```

## Running Tests

### Manual Testing

Use the test scenarios as prompts:

```bash
# Test ownership skill triggering
claude -p "Why am I getting E0382 error?"

# Test unsafe-checker skill
claude -p "Review this unsafe code: unsafe { *ptr }"

# Test crate-researcher agent
claude -p "What's the latest version of tokio?"
```

### Validation Script

**Linux/macOS:**
```bash
./tests/validation/validate-skills.sh
```

**Windows:**
```powershell
.\tests\validation\validate-skills.ps1
```

## Test Categories

### 1. Skill Triggering Tests
Verify correct skills are triggered by keywords.

### 2. Content Accuracy Tests
Verify skills provide accurate information.

### 3. Agent Integration Tests
Verify agents fetch data correctly.

### 4. Routing Tests
Verify rust-router routes to correct skills.

### 5. Cache Tests
Verify caching mechanism works.

## Adding New Tests

1. Create scenario file in `tests/scenarios/`
2. Include:
   - Test prompt
   - Expected skill trigger
   - Expected response elements
3. Update validation script if needed
