# Shell 脚本引用汇总

本文档记录了项目中所有 shell 脚本的位置、对应的 PowerShell 版本以及引用位置。

## 脚本列表

### 1. rust-skill-eval-hook

**位置:**
- Bash: `.claude/hooks/rust-skill-eval-hook.sh`
- PowerShell: `.claude/hooks/rust-skill-eval-hook.ps1`

**功能:** 强制 Claude 使用元认知路由框架

**引用位置:**

#### Hook 配置
- `hooks/hooks.json:9-10` - Windows 平台引用 .ps1
- `hooks/hooks.json:14-15` - Linux/macOS 平台引用 .sh

#### 文档引用
- `docs/forced-eval-hook.md:104` - 示例配置
- `docs/architecture-zh.md:15` - 架构说明
- `docs/architecture-zh.md:75` - 目录结构
- `docs/architecture-zh.md:223` - 流程图
- `docs/architecture-zh.md:303` - Hook 脚本说明
- `docs/architecture-zh.md:604` - 组件表格
- `docs/hook-mechanism-zh.md:57` - Hook 机制说明
- `docs/hook-mechanism-zh.md:68` - 流程图
- `docs/hook-mechanism-zh.md:102` - 配置示例
- `docs/hook-mechanism-zh.md:160` - 脚本说明
- `docs/hook-mechanism-zh.md:336` - 目录结构
- `docs/hook-mechanism-zh.md:509` - 配置示例
- `docs/hook-mechanism-zh.md:518` - 脚本标题
- `docs/skills-design-lessons.md:179` - 配置示例
- `docs/skills-design-lessons.md:367` - 文件列表
- `docs/skill-inheritance.md:273` - 使用示例

#### 测试脚本引用
- `test-triggers.sh:115` - 错误提示信息
- `test-triggers.ps1:95` - 错误提示信息

---

### 2. validate-skills

**位置:**
- Bash: `tests/validation/validate-skills.sh`
- PowerShell: `tests/validation/validate-skills.ps1`

**功能:** 验证 skills 配置是否正确

**引用位置:**

#### 文档引用
- `tests/README.md:21-22` - 目录结构
- `tests/README.md:44-52` - 使用说明（包含 Windows 版本）

---

### 3. quality-check

**位置:**
- Bash: `scripts/quality-check.sh`
- PowerShell: `scripts/quality-check.ps1`

**功能:** 发布前质量检查

**引用位置:**

#### 文档引用
- `docs/skills-design-lessons.md:405` - 使用示例

---

### 4. analyze-skills

**位置:**
- Bash: `scripts/analyze-skills.sh`
- PowerShell: `scripts/analyze-skills.ps1`

**功能:** 分析 rust-skills 结构和内容统计

**引用位置:**
- 无直接文档引用

---

### 5. generate-index

**位置:**
- Bash: `scripts/generate-index.sh`
- PowerShell: `scripts/generate-index.ps1`

**功能:** 生成索引文件

**引用位置:**
- 无直接文档引用

---

### 6. setup

**位置:**
- Bash: `setup.sh`
- PowerShell: `setup.ps1`

**功能:** 设置 Rust Skills 环境

**引用位置:**
- 无直接文档引用

---

### 7. test-triggers

**位置:**
- Bash: `test-triggers.sh`
- PowerShell: `test-triggers.ps1`

**功能:** 测试 Hook 触发机制

**引用位置:**

#### 文档引用
- `REVIEW.md:193` - 脚本名称
- `REVIEW.md:230` - 测试脚本说明

#### 自引用
- `test-triggers.sh:6-9` - 使用说明

---

## 使用建议

### Linux/macOS 用户
使用 `.sh` 脚本:
```bash
./setup.sh
./test-triggers.sh
./scripts/quality-check.sh
./scripts/analyze-skills.sh
./scripts/generate-index.sh
./tests/validation/validate-skills.sh
```

### Windows 用户
使用 `.ps1` 脚本:
```powershell
.\setup.ps1
.\test-triggers.ps1
.\scripts\quality-check.ps1
.\scripts\analyze-skills.ps1
.\scripts\generate-index.ps1
.\tests\validation\validate-skills.ps1
```

## Hook 配置说明

`hooks/hooks.json` 已配置为根据平台自动选择正确的脚本:
- Windows (win32): 使用 `.ps1` 脚本
- Linux/macOS (darwin/linux): 使用 `.sh` 脚本

无需手动修改配置,系统会自动根据运行平台选择对应脚本。

## 注意事项

1. **权限设置**
   - Linux/macOS: 确保 `.sh` 脚本有执行权限 (`chmod +x`)
   - Windows: 可能需要设置 PowerShell 执行策略 (`Set-ExecutionPolicy`)

2. **路径分隔符**
   - Linux/macOS: 使用 `/`
   - Windows: 使用 `\`

3. **脚本功能一致性**
   - 所有 `.ps1` 脚本与对应的 `.sh` 脚本功能完全一致
   - 仅语法适配不同平台

## 更新日志

- 2026-01-18: 创建所有 PowerShell 版本脚本
- 2026-01-18: 更新 hooks.json 支持跨平台
- 2026-01-18: 更新文档添加 Windows 使用说明
