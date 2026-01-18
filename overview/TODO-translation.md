# Rust Skills 文档翻译任务清单

> 本文件记录所有需要翻译为中文的文档及其翻译进度

## 翻译原则

1. **保留技术术语**：Rust、cargo、trait、ownership 等技术术语保持英文
2. **保留代码示例**：所有代码块保持原样
3. **保留链接**：文件路径和 URL 保持原样
4. **统一术语**：使用统一的中文技术术语翻译
5. **保持格式**：保持原文档的 Markdown 格式结构

## 翻译状态说明

- ⬜ 未开始
- 🔄 进行中
- ✅ 已完成
- ⏭️ 跳过（已有中文版）

---

## 一、核心文档（优先级：高）

### 1.1 项目根目录

| 文件 | 状态 | 译文路径 | 备注 |
|------|------|----------|------|
| README.md | ⏭️ | README-zh.md | 已存在 |
| AGENTS.md | ⬜ | AGENTS-zh.md | Agent 使用说明 |
| CHANGELOG.md | ⬜ | CHANGELOG-zh.md | 变更日志 |
| CLAUDE.md | ⬜ | - | Claude 指令（保持英文） |

### 1.2 安装文档

| 文件 | 状态 | 译文路径 | 备注 |
|------|------|----------|------|
| .codex/INSTALL.md | ⬜ | .codex/INSTALL-zh.md | Codex 安装指南 |
| .opencode/INSTALL.md | ⬜ | .opencode/INSTALL-zh.md | OpenCode 安装指南 |
| .opencode/plugin/instructions.md | ⬜ | .opencode/plugin/instructions-zh.md | 插件说明 |

---

## 二、文档目录（优先级：高）

### 2.1 架构与设计文档

| 文件 | 状态 | 译文路径 | 备注 |
|------|------|----------|------|
| docs/capabilities-summary.md | ⏭️ | docs/capabilities-summary-zh.md | 已存在 |
| docs/meta-cognition-example-e0382.md | ⬜ | docs/meta-cognition-example-e0382-zh.md | 元认知示例 |
| docs/problem-solved.md | ⬜ | docs/problem-solved-zh.md | 解决的问题 |
| docs/what-is-a-skill.md | ⬜ | docs/what-is-a-skill-zh.md | Skill 概念 |
| docs/skills-testing.md | ⬜ | docs/skills-testing-zh.md | Skill 测试 |
| docs/skills-best-practices.md | ⬜ | docs/skills-best-practices-zh.md | 最佳实践 |
| docs/skills-design-lessons.md | ⬜ | docs/skills-design-lessons-zh.md | 设计经验 |
| docs/skill-inheritance.md | ⬜ | docs/skill-inheritance-zh.md | Skill 继承 |
| docs/docs-cache-spec.md | ⬜ | docs/docs-cache-spec-zh.md | 文档缓存规范 |
| docs/forced-eval-hook.md | ⬜ | docs/forced-eval-hook-zh.md | 强制评估钩子 |

### 2.2 介绍文档

| 文件 | 状态 | 译文路径 | 备注 |
|------|------|----------|------|
| docs/rust-skills-introduction-v1.md | ⬜ | docs/rust-skills-introduction-v1-zh.md | 介绍 v1 |
| docs/rust-skills-introduction-v2.md | ⬜ | docs/rust-skills-introduction-v2-zh.md | 介绍 v2 |

### 2.3 测试用例

| 文件 | 状态 | 译文路径 | 备注 |
|------|------|----------|------|
| docs/test-cases/meta-cognition-test-suite.md | ⬜ | docs/test-cases/meta-cognition-test-suite-zh.md | 元认知测试套件 |

---

## 三、元数据文档（优先级：中）

| 文件 | 状态 | 译文路径 | 备注 |
|------|------|----------|------|
| _meta/error-protocol.md | ⬜ | _meta/error-protocol-zh.md | 错误协议 |
| _meta/externalization.md | ⬜ | _meta/externalization-zh.md | 外部化 |
| _meta/hooks-patterns.md | ⬜ | _meta/hooks-patterns-zh.md | 钩子模式 |
| _meta/layer-definitions.md | ⬜ | _meta/layer-definitions-zh.md | 层定义 |
| _meta/reasoning-framework.md | ⬜ | _meta/reasoning-framework-zh.md | 推理框架 |

---

## 四、Agent 文档（优先级：中）

| 文件 | 状态 | 译文路径 | 备注 |
|------|------|----------|------|
| agents/browser-fetcher.md | ⬜ | agents/browser-fetcher-zh.md | 浏览器获取器 |
| agents/clippy-researcher.md | ⬜ | agents/clippy-researcher-zh.md | Clippy 研究员 |
| agents/crate-researcher.md | ⬜ | agents/crate-researcher-zh.md | Crate 研究员 |
| agents/rust-changelog.md | ⬜ | agents/rust-changelog-zh.md | Rust 变更日志 |
| agents/rust-daily-reporter.md | ⬜ | agents/rust-daily-reporter-zh.md | Rust 日报 |
| agents/docs-cache.md | ⬜ | agents/docs-cache-zh.md | 文档缓存 |
| agents/docs-researcher.md | ⬜ | agents/docs-researcher-zh.md | 文档研究员 |
| agents/std-docs-researcher.md | ⬜ | agents/std-docs-researcher-zh.md | 标准库文档研究员 |
| agents/_shared/fetch-strategy.md | ⬜ | agents/_shared/fetch-strategy-zh.md | 获取策略 |

---

## 五、命令文档（优先级：中）

| 文件 | 状态 | 译文路径 | 备注 |
|------|------|----------|------|
| commands/audit.md | ⬜ | commands/audit-zh.md | 审计命令 |
| commands/cache-clean.md | ⬜ | commands/cache-clean-zh.md | 缓存清理 |
| commands/cache-status.md | ⬜ | commands/cache-status-zh.md | 缓存状态 |
| commands/clean-crate-skills.md | ⬜ | commands/clean-crate-skills-zh.md | 清理 crate skills |
| commands/crate-info.md | ⬜ | commands/crate-info-zh.md | Crate 信息 |
| commands/create-llms-for-skills.md | ⬜ | commands/create-llms-for-skills-zh.md | 为 skills 创建 LLMs |
| commands/create-skills-via-llms.md | ⬜ | commands/create-skills-via-llms-zh.md | 通过 LLMs 创建 skills |
| commands/docs.md | ⬜ | commands/docs-zh.md | 文档命令 |
| commands/fix-skill-docs.md | ⬜ | commands/fix-skill-docs-zh.md | 修复 skill 文档 |
| commands/guideline.md | ⬜ | commands/guideline-zh.md | 指南命令 |
| commands/router.md | ⬜ | commands/router-zh.md | 路由命令 |
| commands/rust-daily.md | ⬜ | commands/rust-daily-zh.md | Rust 日报命令 |
| commands/rust-features.md | ⬜ | commands/rust-features-zh.md | Rust 特性命令 |
| commands/rust-review.md | ⬜ | commands/rust-review-zh.md | Rust 审查命令 |
| commands/skill-index.md | ⬜ | commands/skill-index-zh.md | Skill 索引命令 |
| commands/sync-crate-skills.md | ⬜ | commands/sync-crate-skills-zh.md | 同步 crate skills |
| commands/unsafe-check.md | ⬜ | commands/unsafe-check-zh.md | Unsafe 检查 |
| commands/unsafe-review.md | ⬜ | commands/unsafe-review-zh.md | Unsafe 审查 |
| commands/update-crate-skill.md | ⬜ | commands/update-crate-skill-zh.md | 更新 crate skill |

---

## 六、索引文档（优先级：低）

| 文件 | 状态 | 译文路径 | 备注 |
|------|------|----------|------|
| index/agents-index.md | ⬜ | index/agents-index-zh.md | Agent 索引 |
| index/commands-index.md | ⬜ | index/commands-index-zh.md | 命令索引 |
| index/domain-extensions.md | ⬜ | index/domain-extensions-zh.md | 领域扩展 |
| index/error-codes.md | ⬜ | index/error-codes-zh.md | 错误码 |
| index/meta-questions.md | ⬜ | index/meta-questions-zh.md | 元问题 |
| index/skills-index.md | ⬜ | index/skills-index-zh.md | Skills 索引 |
| index/tech-categories.md | ⬜ | index/tech-categories-zh.md | 技术分类 |
| index/triggers-index.md | ⬜ | index/triggers-index-zh.md | 触发器索引 |

---

## 七、Skills 文档（优先级：高）

### 7.1 核心 Skills

| 文件 | 状态 | 译文路径 | 备注 |
|------|------|----------|------|
| skills/rust-router/SKILL.md | ⬜ | skills/rust-router/SKILL-zh.md | 路由器 |
| skills/rust-learner/SKILL.md | ⬜ | skills/rust-learner/SKILL-zh.md | 学习器 |
| skills/coding-guidelines/SKILL.md | ⬜ | skills/coding-guidelines/SKILL-zh.md | 编码规范 |
| skills/rust-daily/SKILL.md | ⬜ | skills/rust-daily/SKILL-zh.md | Rust 日报 |
| skills/rust-skill-creator/SKILL.md | ⬜ | skills/rust-skill-creator/SKILL-zh.md | Skill 创建器 |

### 7.2 Layer 1: 语言机制 (m01-m07)

| 文件 | 状态 | 译文路径 | 备注 |
|------|------|----------|------|
| skills/m01-ownership/SKILL.md | ⬜ | skills/m01-ownership/SKILL-zh.md | 所有权 |
| skills/m01-ownership/comparison.md | ⬜ | skills/m01-ownership/comparison-zh.md | 对比 |
| skills/m01-ownership/examples/best-practices.md | ⬜ | skills/m01-ownership/examples/best-practices-zh.md | 最佳实践 |
| skills/m01-ownership/patterns/common-errors.md | ⬜ | skills/m01-ownership/patterns/common-errors-zh.md | 常见错误 |
| skills/m01-ownership/patterns/lifetime-patterns.md | ⬜ | skills/m01-ownership/patterns/lifetime-patterns-zh.md | 生命周期模式 |
| skills/m02-resource/SKILL.md | ⬜ | skills/m02-resource/SKILL-zh.md | 资源管理 |
| skills/m03-mutability/SKILL.md | ⬜ | skills/m03-mutability/SKILL-zh.md | 可变性 |
| skills/m04-zero-cost/SKILL.md | ⬜ | skills/m04-zero-cost/SKILL-zh.md | 零成本抽象 |
| skills/m05-type-driven/SKILL.md | ⬜ | skills/m05-type-driven/SKILL-zh.md | 类型驱动 |
| skills/m06-error-handling/SKILL.md | ⬜ | skills/m06-error-handling/SKILL-zh.md | 错误处理 |
| skills/m06-error-handling/examples/library-vs-app.md | ⬜ | skills/m06-error-handling/examples/library-vs-app-zh.md | 库 vs 应用 |
| skills/m06-error-handling/patterns/error-patterns.md | ⬜ | skills/m06-error-handling/patterns/error-patterns-zh.md | 错误模式 |
| skills/m07-concurrency/SKILL.md | ⬜ | skills/m07-concurrency/SKILL-zh.md | 并发 |
| skills/m07-concurrency/comparison.md | ⬜ | skills/m07-concurrency/comparison-zh.md | 对比 |
| skills/m07-concurrency/examples/thread-patterns.md | ⬜ | skills/m07-concurrency/examples/thread-patterns-zh.md | 线程模式 |
| skills/m07-concurrency/patterns/async-patterns.md | ⬜ | skills/m07-concurrency/patterns/async-patterns-zh.md | 异步模式 |
| skills/m07-concurrency/patterns/common-errors.md | ⬜ | skills/m07-concurrency/patterns/common-errors-zh.md | 常见错误 |

### 7.3 Layer 2: 设计选择 (m09-m15)

| 文件 | 状态 | 译文路径 | 备注 |
|------|------|----------|------|
| skills/m09-domain/SKILL.md | ⬜ | skills/m09-domain/SKILL-zh.md | 领域建模 |
| skills/m10-performance/SKILL.md | ⬜ | skills/m10-performance/SKILL-zh.md | 性能优化 |
| skills/m10-performance/patterns/optimization-guide.md | ⬜ | skills/m10-performance/patterns/optimization-guide-zh.md | 优化指南 |
| skills/m11-ecosystem/SKILL.md | ⬜ | skills/m11-ecosystem/SKILL-zh.md | 生态系统 |
| skills/m12-lifecycle/SKILL.md | ⬜ | skills/m12-lifecycle/SKILL-zh.md | 生命周期 |
| skills/m13-domain-error/SKILL.md | ⬜ | skills/m13-domain-error/SKILL-zh.md | 领域错误 |
| skills/m14-mental-model/SKILL.md | ⬜ | skills/m14-mental-model/SKILL-zh.md | 心智模型 |
| skills/m14-mental-model/patterns/thinking-in-rust.md | ⬜ | skills/m14-mental-model/patterns/thinking-in-rust-zh.md | Rust 思维 |
| skills/m15-anti-pattern/SKILL.md | ⬜ | skills/m15-anti-pattern/SKILL-zh.md | 反模式 |
| skills/m15-anti-pattern/patterns/common-mistakes.md | ⬜ | skills/m15-anti-pattern/patterns/common-mistakes-zh.md | 常见错误 |

### 7.4 Layer 3: 领域约束 (domain-*)

| 文件 | 状态 | 译文路径 | 备注 |
|------|------|----------|------|
| skills/domain-fintech/SKILL.md | ⬜ | skills/domain-fintech/SKILL-zh.md | 金融科技 |
| skills/domain-ml/SKILL.md | ⬜ | skills/domain-ml/SKILL-zh.md | 机器学习 |
| skills/domain-cloud-native/SKILL.md | ⬜ | skills/domain-cloud-native/SKILL-zh.md | 云原生 |
| skills/domain-iot/SKILL.md | ⬜ | skills/domain-iot/SKILL-zh.md | 物联网 |
| skills/domain-web/SKILL.md | ⬜ | skills/domain-web/SKILL-zh.md | Web 服务 |
| skills/domain-cli/SKILL.md | ⬜ | skills/domain-cli/SKILL-zh.md | 命令行 |
| skills/domain-embedded/SKILL.md | ⬜ | skills/domain-embedded/SKILL-zh.md | 嵌入式 |

### 7.5 其他 Skills

| 文件 | 状态 | 译文路径 | 备注 |
|------|------|----------|------|
| skills/core-actionbook/SKILL.md | ⬜ | skills/core-actionbook/SKILL-zh.md | 核心行动手册 |
| skills/core-agent-browser/SKILL.md | ⬜ | skills/core-agent-browser/SKILL-zh.md | 核心 Agent 浏览器 |
| skills/core-dynamic-skills/SKILL.md | ⬜ | skills/core-dynamic-skills/SKILL-zh.md | 核心动态 Skills |
| skills/core-fix-skill-docs/SKILL.md | ⬜ | skills/core-fix-skill-docs/SKILL-zh.md | 修复 Skill 文档 |

### 7.6 Unsafe Checker

| 文件 | 状态 | 译文路径 | 备注 |
|------|------|----------|------|
| skills/unsafe-checker/SKILL.md | ⬜ | skills/unsafe-checker/SKILL-zh.md | Unsafe 检查器 |
| skills/unsafe-checker/AGENTS.md | ⬜ | skills/unsafe-checker/AGENTS-zh.md | Agent 说明 |
| skills/unsafe-checker/checklists/before-unsafe.md | ⬜ | skills/unsafe-checker/checklists/before-unsafe-zh.md | 使用前检查 |
| skills/unsafe-checker/checklists/common-pitfalls.md | ⬜ | skills/unsafe-checker/checklists/common-pitfalls-zh.md | 常见陷阱 |
| skills/unsafe-checker/checklists/review-unsafe.md | ⬜ | skills/unsafe-checker/checklists/review-unsafe-zh.md | 审查清单 |
| skills/unsafe-checker/examples/ffi-patterns.md | ⬜ | skills/unsafe-checker/examples/ffi-patterns-zh.md | FFI 模式 |
| skills/unsafe-checker/examples/safe-abstraction.md | ⬜ | skills/unsafe-checker/examples/safe-abstraction-zh.md | 安全抽象 |

### 7.7 Unsafe Checker 规则（优先级：低）

所有 `skills/unsafe-checker/rules/*.md` 文件（共 50+ 个规则文件）

建议：规则文件可以批量翻译或按需翻译

### 7.8 Coding Guidelines

| 文件 | 状态 | 译文路径 | 备注 |
|------|------|----------|------|
| skills/coding-guidelines/clippy-lints/_index.md | ⬜ | skills/coding-guidelines/clippy-lints/_index-zh.md | Clippy Lints 索引 |
| skills/coding-guidelines/index/rules-index.md | ⬜ | skills/coding-guidelines/index/rules-index-zh.md | 规则索引 |

---

## 八、测试文档（优先级：低）

| 文件 | 状态 | 译文路径 | 备注 |
|------|------|----------|------|
| tests/README.md | ⬜ | tests/README-zh.md | 测试说明 |
| tests/scenarios/agents.md | ⬜ | tests/scenarios/agents-zh.md | Agent 场景 |
| tests/scenarios/ownership.md | ⬜ | tests/scenarios/ownership-zh.md | 所有权场景 |
| tests/scenarios/routing.md | ⬜ | tests/scenarios/routing-zh.md | 路由场景 |
| tests/scenarios/unsafe.md | ⬜ | tests/scenarios/unsafe-zh.md | Unsafe 场景 |
| tests/pressure-scenarios/m01-ownership/e0382-moved-value.md | ⬜ | tests/pressure-scenarios/m01-ownership/e0382-moved-value-zh.md | E0382 场景 |
| tests/pressure-scenarios/m01-ownership/e0597-lifetime-short.md | ⬜ | tests/pressure-scenarios/m01-ownership/e0597-lifetime-short-zh.md | E0597 场景 |
| tests/pressure-scenarios/m06-error-handling/when-to-unwrap.md | ⬜ | tests/pressure-scenarios/m06-error-handling/when-to-unwrap-zh.md | unwrap 场景 |
| tests/pressure-scenarios/m07-concurrency/send-sync-bounds.md | ⬜ | tests/pressure-scenarios/m07-concurrency/send-sync-bounds-zh.md | Send/Sync 场景 |

---

## 九、其他文档（优先级：低）

| 文件 | 状态 | 译文路径 | 备注 |
|------|------|----------|------|
| cache/README.md | ⬜ | cache/README-zh.md | 缓存说明 |
| templates/README.md | ⬜ | templates/README-zh.md | 模板说明 |
| templates/decision.md | ⬜ | templates/decision-zh.md | 决策模板 |
| templates/findings.md | ⬜ | templates/findings-zh.md | 发现模板 |
| templates/trace.md | ⬜ | templates/trace-zh.md | 追踪模板 |
| overview/dep依赖关系.md | ⏭️ | - | 已是中文 |
| overview/ref引用.md | ⏭️ | - | 已是中文 |
| overview/trigger触发.md | ⏭️ | - | 已是中文 |
| RECORD.md | ⬜ | RECORD-zh.md | 记录 |
| REVIEW.md | ⬜ | REVIEW-zh.md | 审查 |
| test-triggers.md | ⬜ | test-triggers-zh.md | 测试触发器 |

---

## 翻译进度统计

- **总文件数**: 约 200+ 个 Markdown 文件
- **已完成**: 6 个（已有中文版）
- **进行中**: 0 个
- **未开始**: 约 194 个

### 按优先级统计

- **高优先级**: 约 80 个文件（核心文档、Skills、架构文档）
- **中优先级**: 约 60 个文件（Agent、命令、元数据）
- **低优先级**: 约 60 个文件（索引、测试、规则细节）

---

## 翻译建议

### 第一阶段：核心文档（1-2 周）
1. README.md 相关
2. 安装文档
3. 核心架构文档（docs/）
4. 核心 Skills（rust-router, rust-learner, coding-guidelines）

### 第二阶段：Skills 文档（2-3 周）
1. Layer 1 Skills (m01-m07)
2. Layer 2 Skills (m09-m15)
3. Layer 3 Skills (domain-*)
4. Unsafe Checker 核心文档

### 第三阶段：支持文档（1-2 周）
1. Agent 文档
2. 命令文档
3. 元数据文档

### 第四阶段：补充文档（按需）
1. 索引文档
2. 测试文档
3. Unsafe Checker 规则细节

---

## 更新日志

- 2026-01-19: 创建翻译任务清单，识别约 200+ 个待翻译文件
