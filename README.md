# Stride

[![npm version](https://img.shields.io/npm/v/stride-ai-workflow.svg)](https://www.npmjs.com/package/stride-ai-workflow)
[![npm downloads](https://img.shields.io/npm/dm/stride-ai-workflow.svg)](https://www.npmjs.com/package/stride-ai-workflow)
[![license](https://img.shields.io/npm/l/stride-ai-workflow.svg)](https://github.com/pagges/Stride/blob/main/LICENSE)

> **S**tructure **T**ask **R**eview **I**terate **D**eploy **E**xecute
>
> **打破 AI 编程工具与团队协作的边界** —— 通过统一项目状态，解决工具间的协作断层，让 AI 与人类开发者真正站在同一条起跑线上。

[English](./README-EN.md) | 中文

---

## 🚀 快速开始

```bash
npx stride-ai-workflow init
```

系统会自动检测你的 AI 工具并完成配置。初始化后，在 AI 工具中输入 `/workflow` 开始使用。

---

## 💡 Stride 是什么？

**Stride** 是一个轻量级的工作流系统，旨在解决 AI 编程工具（Claude Code、Cursor、Qoder 等）在进入团队开发时最核心的问题：**项目状态的同步与协作断层**。

通过一套标准化的文档和命令体系，Stride 充当了 AI 助手与人类开发者之间的“通用协议”，让不论是哪种 AI 工具，都能在同一个任务上下文中无缝协作，抹平了工具对项目状态支持的差异。

### 核心特点

| 特点 | 描述 |
|------|------|
| 🌐 **统一项目状态** | **Stride 的核心价值**。通过结构化文档管理任务状态，确保不同 AI 工具和团队成员共享一致的开发背景。 |
| 🤖 **跨 AI 工具协作** | 支持 Claude Code、Cursor、Qoder、Windsurf、Trae。在 Claude 中生成的任务，在 Cursor 中同样清晰。 |
| 📐 **标准化流程** | 需求 → 设计 → 任务 → 开发 → 测试。让 AI 编码不再是黑箱操作，而是可追踪、可协作的过程。 |
| 👥 **团队天然友好** | 通过 Git 共享工作流。解决“ AI 写的代码只有 AI 懂”的痛点，让人类开发者轻松接手 AI 的工作成果。 |
| 🔄 **迭代闭环** | 内置需求审查、代码审查、Bug 追踪。在一个工作流中完成从 Idea 到 Ready to Deploy 的完整生命周期。 |

---

## 📋 工作流程

```
1️⃣  创建工作流          /workflow
                        ↓
2️⃣  编写需求文档       Requirements.md
                        ↓
3️⃣  AI 审查需求        /doc-review
                        ↓
4️⃣  生成设计文档       Design.md
                        ↓
5️⃣  分解开发任务       Task.md
                        ↓
6️⃣  AI 开发任务        /dev TASK-001
                        ↓
7️⃣  代码审查           /code-review
                        ↓
8️⃣  测试验证           /test
                        ↓
9️⃣  问题追踪           /bug → /fix BUG-001
                        ↓
✅ 功能完成！
```

---

## 🎯 命令参考

### 安装与管理

| 命令 | 描述 |
|------|------|
| `npx stride-ai-workflow init` | 初始化工作流系统 |
| `npx stride-ai-workflow init --ai claude` | 指定 AI 工具初始化 |
| `npx stride-ai-workflow create <名称>` | 创建新工作流 |
| `npx stride-ai-workflow uninstall` | 卸载工作流系统 |
| `npx stride-ai-workflow --help` | 显示帮助信息 |

### AI 工具内命令

初始化完成后，在 Claude Code、Cursor 等 AI 工具中使用：

| 命令 | 描述 |
|------|------|
| `/workflow` | 创建或管理工作流 |
| `/dev TASK-001` | 执行开发任务 |
| `/doc-review` | 审查文档完整性 |
| `/code-review` | 审查代码质量 |
| `/test` | 执行测试 |
| `/bug` | 提交 Bug |
| `/fix BUG-001` | 修复指定 Bug |

---

## 📖 使用示例

### 创建新功能

```bash
# 1. 在 AI 工具中创建工作流
/workflow
# 输入工作流名称，如：user-authentication

# 2. 编写需求文档（系统会自动打开 Requirements.md）

# 3. 让 AI 审查需求
/doc-review

# 4. AI 会生成 Design.md 和 Task.md

# 5. 开始开发
/dev TASK-001

# 6. 代码审查
/code-review

# 7. 执行测试
/test

# 8. 发现问题？记录并修复
/bug
/fix BUG-001
```

---

## 👥 团队协作

Stride 的核心优势在于**状态共享**。通过将 `.stride` 目录纳入版本控制，它成为了 AI 工具与人类开发者之间的“真相源”（Source of Truth），确保所有参与者对任务进度的理解完全一致。

### 启用协作

```bash
# 将工作流提交到代码仓库
git add .stride/
git commit -m "feat: 添加 Stride 工作流系统"
git push
```

### 团队成员加入

```bash
git pull
npx stride-ai-workflow init
```

初始化会自动检测已有配置，团队成员可以立即：
- 📋 查看现有工作流和任务分配
- 🔄 同步任务状态和进度
- 📝 共享需求文档和设计方案
- 🐛 协同追踪和修复问题

### 协作流程示意

```
团队成员 A                     团队成员 B
    │                              │
    ├── 创建工作流 ──────────────► 拉取代码
    │   /workflow                  │
    │                              ├── 查看工作流
    ├── 编写需求 ◄─────────────────┤   /workflow
    │   Requirements.md            │
    │                              ├── 认领任务
    ├── 分解任务 ──────────────────►   /dev TASK-002
    │   Task.md                    │
    │                              │
    ├── /dev TASK-001              ├── 提交代码
    │                              │   git push
    ├── 拉取更新 ◄─────────────────┤
    │   git pull                   │
    │                              │
    └── 代码审查 ──────────────────►
        /code-review
```

### 协作最佳实践

- **及时同步** - 定期执行 `git pull` 获取最新状态
- **明确分工** - 在 Task.md 中标注任务负责人
- **保持沟通** - 通过文档记录决策和变更
- **统一版本** - 团队使用相同版本的 Stride

---

## 📁 项目结构

初始化后的目录结构：

```
your-project/
├── .claude/commands/          # AI 工具命令（自动生成）
│   ├── workflow.md
│   ├── dev.md
│   ├── doc-review.md
│   ├── code-review.md
│   ├── bug.md
│   ├── fix.md
│   └── test.md
│
├── .stride/template/          # 工作流模板和脚本
│
└── .stride/stride-<名称>/     # 工作流目录（/workflow 创建）
    ├── Workflow.md            # 工作流状态
    ├── Requirements.md        # 需求文档
    ├── Design.md              # 设计文档
    ├── Task.md                # 任务分解
    ├── BugList.md             # 问题追踪
    └── TestCase.md            # 测试用例
```

---

## 💡 最佳实践

### ✅ 推荐

- 📝 在 Requirements.md 中详细描述功能需求
- 🎯 一个工作流对应一个功能或特性
- 🔍 充分利用 AI 的代码审查能力
- 🧪 为重要功能编写测试用例
- 📊 及时使用 `/bug` 记录问题

### ❌ 避免

- 跳过需求文档直接开发
- 在一个工作流中做太多功能
- 忽视代码审查的建议
- 不测试就合并代码

---

## 🌍 系统要求

| 要求 | 版本 |
|------|------|
| Node.js | >= 18.0.0 |
| Git | 任意版本 |
| Bash | macOS/Linux 自带，Windows 需 WSL |

### 支持的平台

✅ macOS · ✅ Linux · ✅ Windows (WSL)

### 支持的 AI 工具

✅ Claude Code · ✅ Cursor · ✅ Qoder · ✅ Windsurf · ✅ Trae

---

## 🗑️ 卸载

```bash
# 交互式卸载（需确认）
npx stride-ai-workflow uninstall

# 强制卸载，跳过确认
npx stride-ai-workflow uninstall --force

# 卸载但保留工作流数据
npx stride-ai-workflow uninstall --keep-workflows
```

---

## 📚 更多文档

- [NPM 安装指南](./docs/NPM_INSTALLATION.md)
- [本地测试指南](./docs/LOCAL_TESTING.md)
- [发布指南](./docs/PUBLISHING.md)

---

## 🤝 贡献

欢迎贡献！请查看 [贡献指南](./CONTRIBUTING.md)。

- 🐛 遇到问题？提交 [Issue](https://github.com/pagges/Stride/issues)
- 💡 有想法？欢迎 [Pull Request](https://github.com/pagges/Stride/pulls)

---

## 📝 许可证

MIT License - 参见 [LICENSE](./LICENSE)

---
<div align="center">

**[npm](https://www.npmjs.com/package/stride-ai-workflow) · [文档](./docs/) · [讨论](https://github.com/pagges/Stride/discussions) · [反馈](https://github.com/pagges/Stride/issues)**

Made with ❤️ for developers everywhere

</div>
