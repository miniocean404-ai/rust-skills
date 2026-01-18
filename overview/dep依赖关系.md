# Rust Skills 文件夹依赖关系与执行流程

本文档详细说明 Claude 执行 rust-skills 时各个文件夹的依赖关系和调用顺序。

---

## 📊 整体执行流程

```
用户提问
    ↓
hooks/ (触发检测)
    ↓
.claude/hooks/ (注入指令)
    ↓
skills/ (加载技能)
    ↓
_meta/ (元认知框架)
    ↓
agents/ (实时数据获取)
    ↓
cache/ (缓存查询)
    ↓
commands/ (可选命令)
    ↓
templates/ (可选模板)
    ↓
index/ (索引查询)
    ↓
docs/ (文档参考)
    ↓
输出答案
```

---

## 🗂️ 文件夹详细说明

### 1. hooks/ - Hook 触发配置

**文件**: `hooks/hooks.json`

**职责**:
- 监听用户输入 (UserPromptSubmit 事件)
- 使用正则表达式匹配 400+ 关键词
- 决定是否触发 Hook 脚本

**依赖关系**:
```
hooks/hooks.json
    ↓ 触发
.claude/hooks/rust-skill-eval-hook.sh/ps1
```

**执行时机**: 用户提交问题时 (最先执行)

**被依赖**: 无 (入口点)

**依赖**: `.claude/hooks/` (触发后执行)

---

### 2. .claude/hooks/ - Hook 脚本

**文件**:
- `rust-skill-eval-hook.sh` (Linux/macOS)
- `rust-skill-eval-hook.ps1` (Windows)

**职责**:
- 注入元认知指令到 Claude
- 强制要求调用 `Skill(rust-router)`
- 强制输出格式要求

**依赖关系**:
```
.claude/hooks/rust-skill-eval-hook.sh/ps1
    ↓ 注入指令
Claude 接收到:
    - 用户问题
    - 元认知指令 (包含 "Always invoke Skill(rust-router) first")
    ↓ 执行
skills/rust-router/
```

**执行时机**: hooks.json 匹配成功后

**被依赖**: `hooks/`

**依赖**: `skills/rust-router/` (强制调用)

---

### 3. skills/ - 技能文件夹

**结构**:
```
skills/
├── rust-router/          # 路由入口 (必须首先加载)
├── m01-m07/             # Layer 1: 语言机制
├── m09-m15/             # Layer 2: 设计选择
├── domain-*/            # Layer 3: 领域约束
├── unsafe-checker/      # 特殊: unsafe 审查
├── coding-guidelines/   # 特殊: 代码规范
├── rust-learner/        # 特殊: 信息获取路由
├── rust-daily/          # 特殊: 新闻聚合
└── core-*/              # 内部工具技能
```

**职责**:
- 提供认知框架和决策指引
- 不是知识库,是思考协议
- 通过 Trace Up/Down 相互引用

**依赖关系**:
```
skills/rust-router/
    ↓ 路由决策
skills/m0x-*/ (Layer 1)
skills/m1x-*/ (Layer 2)
skills/domain-*/ (Layer 3)
    ↓ 引用
_meta/ (元认知框架)
    ↓ 需要实时数据时
agents/ (实时信息)
    ↓ 查询缓存
cache/ (缓存数据)
```

**执行时机**: Hook 脚本注入指令后,Claude 首先调用 rust-router

**被依赖**: `.claude/hooks/` (强制调用 rust-router)

**依赖**: `_meta/`, `agents/`, `cache/`, `index/`

**特殊说明**:
- `rust-router` 是唯一入口,其他技能通过它路由
- 技能之间通过 Trace Up/Down 相互引用
- 技能可以调用 agents 获取实时数据

---

### 4. _meta/ - 元认知框架

**文件**:
```
_meta/
├── reasoning-framework.md   # 追溯框架 (如何 Trace Up/Down)
├── layer-definitions.md     # 三层模型定义
├── error-protocol.md        # 3-Strike 升级规则
├── externalization.md       # 认知外化
└── hooks-patterns.md        # Hook 模式
```

**职责**:
- 定义元认知框架
- 指导技能如何追溯
- 定义三层模型 (L1/L2/L3)

**依赖关系**:
```
_meta/
    ↑ 被引用
skills/ (所有技能都遵循 _meta 定义的框架)
```

**执行时机**: 技能加载时作为框架参考

**被依赖**: `skills/` (所有技能)

**依赖**: 无 (基础框架)

---

### 5. agents/ - 实时数据获取

**文件**:
```
agents/
├── rust-changelog.md        # Rust 版本信息
├── crate-researcher.md      # Crate 元数据 (crates.io)
├── docs-researcher.md       # API 文档 (docs.rs)
├── std-docs-researcher.md   # 标准库文档
├── clippy-researcher.md     # Clippy lint 信息
├── rust-daily-reporter.md   # 生态新闻
├── browser-fetcher.md       # 浏览器自动化
└── _shared/fetch-strategy.md # 共享策略
```

**职责**:
- 获取实时数据 (版本、文档、新闻)
- 不是技能,是后台研究工具
- 通过 WebFetch/WebSearch 获取数据

**依赖关系**:
```
agents/
    ↓ 查询缓存
cache/ (先查缓存,避免重复请求)
    ↓ 缓存未命中
WebFetch/WebSearch (实时获取)
```

**执行时机**: 技能需要实时数据时调用

**被依赖**: `skills/` (特别是 rust-learner, m11-ecosystem)

**依赖**: `cache/`, WebFetch, WebSearch

**调用方式**:
```
skills/rust-learner/
    → 调用 agents/rust-changelog (查询 Rust 版本)
    → 调用 agents/crate-researcher (查询 crate 信息)
```

---

### 6. cache/ - 缓存系统

**结构**:
```
cache/
├── config.yaml          # 缓存配置
├── README.md           # 缓存说明
├── crates/             # Crate 元数据缓存
├── rust-versions/      # Rust 版本缓存
└── docs/               # 文档缓存
```

**职责**:
- 缓存 agents 获取的数据
- 减少重复网络请求
- 15 分钟自清理缓存

**依赖关系**:
```
cache/
    ↑ 查询
agents/ (先查缓存)
    ↑ 写入
agents/ (获取新数据后写入缓存)
```

**执行时机**: agents 查询数据前先查缓存

**被依赖**: `agents/`

**依赖**: 无 (存储层)

---

### 7. commands/ - 斜杠命令

**文件**:
```
commands/
├── rust-features.md         # /rust-features
├── crate-info.md           # /crate-info
├── sync-crate-skills.md    # /sync-crate-skills
├── docs.md                 # /docs
├── rust-review.md          # /rust-review
├── unsafe-check.md         # /unsafe-check
├── rust-daily.md           # /rust-daily
└── ...
```

**职责**:
- 提供用户可调用的命令
- 不是自动触发,需要用户主动调用
- 通常调用 agents 或 skills

**依赖关系**:
```
commands/
    ↓ 调用
agents/ (获取数据)
skills/ (执行逻辑)
cache/ (查询缓存)
```

**执行时机**: 用户主动调用 (如 `/rust-features`)

**被依赖**: 无 (用户主动调用)

**依赖**: `agents/`, `skills/`, `cache/`

**示例**:
```
用户: /crate-info tokio
    ↓
commands/crate-info.md
    ↓ 调用
agents/crate-researcher.md
    ↓ 查询
cache/crates/tokio.json
    ↓ 缓存未命中
WebFetch crates.io API
```

---

### 8. templates/ - 输出模板

**文件**:
```
templates/
├── trace.md         # 追溯模板
├── findings.md      # 发现模板
└── decision.md      # 决策模板
```

**职责**:
- 提供结构化输出模板
- 确保输出格式一致

**依赖关系**:
```
templates/
    ↑ 引用
skills/ (输出时使用模板)
```

**执行时机**: 技能输出答案时参考

**被依赖**: `skills/`

**依赖**: 无 (模板文件)

---

### 9. index/ - 索引文件

**文件**:
```
index/
├── skills-index.md          # 技能索引
├── commands-index.md        # 命令索引
├── error-codes.md           # 错误码索引
├── triggers-index.md        # 触发词索引
├── tech-categories.md       # 技术分类
├── domain-extensions.md     # 领域扩展
└── meta-questions.md        # 元问题索引
```

**职责**:
- 提供快速查询索引
- 帮助 Claude 快速定位技能
- 不是必须,但提高效率

**依赖关系**:
```
index/
    ↑ 查询
skills/rust-router/ (路由时查询索引)
```

**执行时机**: rust-router 路由时可选查询

**被依赖**: `skills/rust-router/`

**依赖**: 无 (索引文件)

---

### 10. docs/ - 文档

**文件**:
```
docs/
├── capabilities-summary.md      # 能力总结
├── architecture-zh.md           # 架构文档
├── what-is-a-skill.md          # Skill 定义
├── skills-design-lessons.md    # 设计经验
├── problem-solved.md           # 解决的问题
└── test-cases/                 # 测试用例
```

**职责**:
- 项目文档
- 设计说明
- 不参与执行流程

**依赖关系**:
```
docs/
    ↑ 参考
开发者/用户 (理解项目)
```

**执行时机**: 不参与执行,仅供阅读

**被依赖**: 无

**依赖**: 无

---

### 11. scripts/ - 维护脚本

**文件**:
```
scripts/
├── analyze-skills.sh/ps1       # 分析技能结构
├── generate-index.sh/ps1       # 生成索引
└── quality-check.sh/ps1        # 质量检查
```

**职责**:
- 项目维护工具
- 不参与 Claude 执行流程

**依赖关系**:
```
scripts/
    ↓ 分析/生成
skills/, index/ (维护目标)
```

**执行时机**: 开发者手动执行

**被依赖**: 无

**依赖**: `skills/`, `index/`

---

## 🔄 完整执行流程示例

### 示例 1: 简单问题 (E0382 错误)

```
1. 用户输入: "E0382 错误怎么解决"
    ↓
2. hooks/hooks.json
    - 匹配 "E0382" ✓
    - 触发 Hook
    ↓
3. .claude/hooks/rust-skill-eval-hook.sh
    - 注入元认知指令
    - 强制调用 Skill(rust-router)
    ↓
4. skills/rust-router/SKILL.md
    - 识别: E0382 → m01-ownership
    - 决策: 单技能加载
    ↓
5. skills/m01-ownership/SKILL.md
    - 加载技能内容
    - 参考 _meta/reasoning-framework.md (追溯框架)
    - 分析所有权错误
    ↓
6. 输出答案
    - 使用 templates/trace.md 格式
    - 输出推理链和解决方案
```

**涉及文件夹**: hooks → .claude/hooks → skills → _meta → templates

---

### 示例 2: 需要实时数据 (tokio 最新版本)

```
1. 用户输入: "tokio 最新版本是多少"
    ↓
2. hooks/hooks.json
    - 匹配 "tokio" ✓
    - 触发 Hook
    ↓
3. .claude/hooks/rust-skill-eval-hook.sh
    - 注入元认知指令
    - 强制调用 Skill(rust-router)
    ↓
4. skills/rust-router/SKILL.md
    - 识别: "最新版本" → rust-learner
    - 决策: 路由到 rust-learner
    ↓
5. skills/rust-learner/SKILL.md
    - 识别: crate 版本查询
    - 调用 agents/crate-researcher
    ↓
6. agents/crate-researcher.md
    - 先查询 cache/crates/tokio.json
    - 缓存未命中
    - 使用 WebFetch 查询 crates.io API
    - 写入缓存
    ↓
7. 输出答案
    - 返回 tokio 最新版本信息
```

**涉及文件夹**: hooks → .claude/hooks → skills → agents → cache → WebFetch

---

### 示例 3: 领域问题 (Web API Send 错误)

```
1. 用户输入: "Web API 报错 Rc cannot be sent"
    ↓
2. hooks/hooks.json
    - 匹配 "Web API", "Rc", "Send" ✓
    - 触发 Hook
    ↓
3. .claude/hooks/rust-skill-eval-hook.sh
    - 注入元认知指令
    - 强制调用 Skill(rust-router)
    ↓
4. skills/rust-router/SKILL.md
    - 识别: "Rc", "Send" → m07-concurrency (L1)
    - 识别: "Web API" → domain-web (L3)
    - 决策: 双技能加载 (MANDATORY)
    ↓
5. skills/m07-concurrency/SKILL.md
    - 加载 Layer 1 技能
    - 参考 _meta/reasoning-framework.md
    - Trace Up ↑ 到 domain-web
    ↓
6. skills/domain-web/SKILL.md
    - 加载 Layer 3 技能
    - 分析 Web 领域约束
    - Trace Down ↓ 到 m02-resource (Arc)
    ↓
7. skills/m02-resource/SKILL.md
    - 提供 Arc 实现指引
    ↓
8. 输出答案
    - 使用 templates/trace.md 格式
    - 输出完整推理链:
      - Layer 1: Send/Sync 错误
      - Layer 3: Web 领域约束
      - Layer 2: Arc<T> 设计决策
```

**涉及文件夹**: hooks → .claude/hooks → skills (多个) → _meta → templates

---

### 示例 4: 用户命令 (/sync-crate-skills)

```
1. 用户输入: "/sync-crate-skills"
    ↓
2. commands/sync-crate-skills.md
    - 读取命令指令
    - 扫描 Cargo.toml
    - 解析依赖列表
    ↓
3. 对每个 crate:
    ↓
4. agents/crate-researcher.md
    - 查询 cache/crates/{crate}.json
    - 缓存未命中则 WebFetch
    ↓
5. 生成动态技能
    - 写入 ~/.claude/skills/{crate}/SKILL.md
    ↓
6. 输出结果
    - 报告生成的技能列表
```

**涉及文件夹**: commands → agents → cache → 外部 (~/.claude/skills/)

---

## 📊 依赖关系图

### 核心依赖图

```
                    用户输入
                        ↓
                   hooks/
                        ↓
              .claude/hooks/
                        ↓
                   skills/
                    ↙  ↓  ↘
              _meta/  agents/  templates/
                        ↓
                    cache/
                        ↓
                  WebFetch/WebSearch
```

### 详细依赖图

```
hooks/hooks.json
    ↓ 触发
.claude/hooks/rust-skill-eval-hook.sh/ps1
    ↓ 强制调用
skills/rust-router/
    ↓ 路由到
    ├─→ skills/m01-m07/ (Layer 1)
    │       ↓ 参考
    │       _meta/reasoning-framework.md
    │       ↓ Trace Up
    │       skills/m09-m15/ (Layer 2)
    │       skills/domain-*/ (Layer 3)
    │
    ├─→ skills/m09-m15/ (Layer 2)
    │       ↓ 参考
    │       _meta/layer-definitions.md
    │       ↓ Trace Up/Down
    │       skills/domain-*/ (Layer 3)
    │       skills/m01-m07/ (Layer 1)
    │
    ├─→ skills/domain-*/ (Layer 3)
    │       ↓ Trace Down
    │       skills/m01-m07/ (Layer 1)
    │       skills/m09-m15/ (Layer 2)
    │
    ├─→ skills/rust-learner/
    │       ↓ 调用
    │       agents/rust-changelog
    │       agents/crate-researcher
    │           ↓ 查询
    │           cache/
    │               ↓ 缓存未命中
    │               WebFetch/WebSearch
    │
    └─→ skills/unsafe-checker/
            ↓ 参考
            _meta/error-protocol.md

commands/ (用户主动调用)
    ↓ 调用
    agents/
    skills/
    cache/

index/ (可选查询)
    ↑ 被引用
    skills/rust-router/

templates/ (输出格式)
    ↑ 被引用
    skills/

docs/ (文档,不参与执行)
scripts/ (维护工具,不参与执行)
```

---

## 🎯 关键依赖规则

### 1. 强制入口规则

```
所有问题必须通过:
hooks/ → .claude/hooks/ → skills/rust-router/
```

**不能跳过**: rust-router 是唯一入口

---

### 2. 技能加载顺序

```
1. rust-router (路由决策)
2. Layer 1/2/3 技能 (根据路由结果)
3. _meta (框架参考)
4. agents (需要实时数据时)
5. cache (agents 查询前)
```

---

### 3. 数据获取优先级

```
1. 技能内容 (静态知识)
2. cache (缓存数据)
3. agents (实时获取)
4. WebFetch/WebSearch (最后手段)
```

---

### 4. 文件夹独立性

**完全独立** (不参与执行):
- `docs/` - 文档
- `scripts/` - 维护脚本

**可选依赖**:
- `index/` - 索引 (提高效率,非必须)
- `templates/` - 模板 (格式化输出,非必须)
- `commands/` - 命令 (用户主动调用)

**核心依赖** (必须):
- `hooks/` - 触发入口
- `.claude/hooks/` - 指令注入
- `skills/` - 技能系统
- `_meta/` - 元认知框架
- `agents/` - 实时数据
- `cache/` - 缓存系统

---

## 📝 总结

### 执行流程特点

1. **单一入口**: 所有问题通过 hooks → .claude/hooks → rust-router
2. **分层加载**: 根据问题类型加载不同层级的技能
3. **缓存优先**: agents 先查缓存,减少网络请求
4. **框架驱动**: _meta 定义元认知框架,所有技能遵循
5. **按需调用**: commands 和 agents 按需调用,不是自动触发

### 文件夹职责

| 文件夹 | 职责 | 执行时机 | 依赖 |
|--------|------|---------|------|
| hooks/ | 触发检测 | 用户提问时 | 无 |
| .claude/hooks/ | 注入指令 | hooks 触发后 | hooks/ |
| skills/ | 技能系统 | 指令注入后 | _meta/, agents/, cache/ |
| _meta/ | 元认知框架 | 技能加载时 | 无 |
| agents/ | 实时数据 | 技能需要时 | cache/ |
| cache/ | 缓存系统 | agents 查询前 | 无 |
| commands/ | 用户命令 | 用户调用时 | agents/, skills/ |
| templates/ | 输出模板 | 输出时 | 无 |
| index/ | 索引查询 | 路由时 (可选) | 无 |
| docs/ | 文档 | 不参与执行 | 无 |
| scripts/ | 维护工具 | 不参与执行 | 无 |

### 关键路径

**最短路径** (简单问题):
```
hooks → .claude/hooks → skills/rust-router → skills/m0x → 输出
```

**完整路径** (复杂问题):
```
hooks → .claude/hooks → skills/rust-router → skills/m0x + domain-*
→ _meta (框架) → agents (数据) → cache (缓存) → 输出
```

**命令路径** (用户命令):
```
commands → agents → cache → 输出
```
