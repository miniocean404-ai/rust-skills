# Rust Skills for OpenCode

## Installation

### Option 1: Copy Plugin Directory

```bash
# Clone rust-skills
git clone https://github.com/ZhangHanDong/rust-skills.git

# Copy to your OpenCode plugins directory
cp -r rust-skills/.opencode/plugin .opencode/plugins/rust-skills
```

### Option 2: Symlink

```bash
git clone https://github.com/ZhangHanDong/rust-skills.git rust-skills
ln -s rust-skills/.opencode/plugin .opencode/plugins/rust-skills
```

## What's Included

This plugin provides Rust development assistance:

- **rust-router**: Master router for all Rust questions
- **rust-learner**: Rust version and crate information
- **coding-guidelines**: Code style and best practices
- **unsafe-checker**: Unsafe code review and FFI guidance
- **m01-m15**: Meta-question skills for ownership, concurrency, error handling, etc.

## Usage

After installation, ask OpenCode about:

- Rust ownership and borrowing
- Error handling patterns
- Async/await and concurrency
- Code style and naming conventions
- Unsafe code review

## Configuration

Add to your OpenCode configuration:

```json
{
  "plugins": {
    "rust-skills": {
      "enabled": true
    }
  }
}
```

## Default Project Settings

When creating Rust projects, use:

```toml
[package]
edition = "2024"
rust-version = "1.85"

[lints.rust]
unsafe_code = "warn"

[lints.clippy]
all = "warn"
pedantic = "warn"
```
