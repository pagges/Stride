# Stride

> **S**tructure **T**ask **R**eview **I**terate **D**eploy **E**xecute
>
> AI-Assisted Development Workflow System - 一行命令启动智能开发工作流

[English](./README-EN.md) | 中文

---

## 🚀 快速开始

### 方式 1：使用 NPM/NPX（推荐）

在你的项目目录运行：

```bash
cd /path/to/your/project
npx stride-ai-workflow init
```

### 方式 2：使用 curl

```bash
cd /path/to/your/project
curl -sSL https://github.com/pagges/Stride/raw/main/install.sh | bash
```

就这样！系统会自动：
- ✅ 检测你的 AI 工具（Claude Code / Qoder / Cursor）
- ✅ 配置工作流命令定义
- ✅ 准备好文档模板和执行规范
- ✅ 创建必要的目录结构

---

## 📋 Stride 是什么？

**Stride** 是一个轻量级的工作流初始化工具，帮助团队快速集成 AI 工具（Claude Code、Qoder、Cursor 等），进行**结构化、高效的软件开发**。一行命令即可为项目配置完整的 AI 编码工作流。

### 核心特点

| 特点 | 说明 |
|------|------|
| 🤖 **AI 驱动** | 集成 Claude Code、Qoder、Cursor 等 AI 编码工具 |
| 📐 **结构化** | 完整的工作流：需求→设计→任务→代码→测试 |
| 🔄 **迭代友好** | 内置代码审查、问题追踪、Bug 修复流程 |
| ⚡ **快速初始化** | 一行命令安装，自动配置 AI 工具集成 |
| 🌍 **跨平台** | 支持 macOS、Linux、Windows（WSL） |
| 📚 **开箱即用** | 初始化后直接在 AI 工具中使用指令 |

---

## 📚 工作流生命周期

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
9️⃣  问题追踪           /bug / /fix BUG-001
                        ↓
✅ 功能完成！
```

---

## 🎯 快速命令

### 初始化工作流系统（一次性）

```bash
# 使用 curl（推荐）
curl -sSL https://github.com/pagges/Stride/raw/main/install.sh | bash

# 或者手动运行
./ai-workflow-system/ai-workflow.sh init
```

### 初始化后在 AI 工具中使用

初始化完成后，在 Claude Code、Qoder 等 AI 工具中直接使用这些指令：

```
/workflow              创建或进入工作流
/dev TASK-001          执行开发任务
/doc-review           审查文档完整性
/code-review          审查代码质量
/bug                  提交 Bug
/fix BUG-001          修复 Bug
/test                 执行测试
```

---

## 📁 项目结构

```
Stride/
├── ai-workflow-system/        # 核心工作流系统（仅初始化）
│   ├── ai-workflow.sh         # 初始化脚本
│   ├── scripts/
│   │   ├── init.sh            # 初始化逻辑
│   │   └── utils.sh           # 工具函数
│   ├── commands/              # AI 工具命令定义
│   └── templates/             # 文档模板
│
├── install.sh                 # 远程安装脚本（curl）
├── setup-workflow.sh          # 本地安装脚本
│
├── docs/                      # 文档
│   ├── QUICK_START.md         # 快速开始
│   ├── TEAM_GUIDE.md          # 团队指南
│   └── ...
│
└── README.md                  # 此文件
```

初始化后，你的项目会自动生成：

```
your-project/
├── .claude/commands/          # Claude Code 指令（自动生成）
│   ├── workflow.md
│   ├── dev.md
│   └── ...
├── .qoder/commands/           # Qoder 指令（如果选择）
├── ai-workflow/               # 工作流系统配置
│   ├── commands/              # 指令说明文档
│   ├── templates/             # 文档模板
│   └── INSTRUCTIONS.md        # AI 执行规范
└── ai-workflow-<name>/        # 后续创建的工作流项目
    ├── Workflow.md            # 工作流状态
    ├── Requirements.md        # 需求文档
    ├── Design.md              # 设计文档
    ├── Task.md                # 任务分解
    ├── BugList.md             # 问题追踪
    └── TestCase.md            # 测试用例
```

---

## 🛠️ 安装方式

### 方式 1：NPM/NPX 安装（推荐）

```bash
# 使用 npx（无需安装，推荐）
cd /path/to/your/project
npx stride-ai-workflow init

# 或全局安装
npm install -g stride-ai-workflow
stride init

# 或作为项目开发依赖
npm install --save-dev stride-ai-workflow
npx stride init
```

### 方式 2：远程 curl 安装

```bash
cd /path/to/your/project
curl -sSL https://github.com/pagges/Stride/raw/main/install.sh | bash
```

### 方式 3：本地安装

```bash
cd /path/to/your/project
bash Stride/setup-workflow.sh
```

初始化完成后会提示选择你使用的 AI 工具（Claude Code / Qoder / Cursor）

### 指定 AI 工具

```bash
# NPM 方式
npx stride-ai-workflow init --ai claude
npx stride-ai-workflow init --ai cursor
npx stride-ai-workflow init --ai qoder

# curl 方式会自动检测
```

---

## 📖 详细文档

- **[快速开始](./docs/QUICK_START.md)** - 5 分钟快速上手
- **[团队指南](./docs/TEAM_GUIDE.md)** - 给团队成员的完整指南
- **[部署说明](./docs/DEPLOYMENT.md)** - 支持 GitHub/GitLab/Gitee
- **[实施清单](./docs/IMPLEMENTATION_CHECKLIST.md)** - 完整的实施步骤
- **[最终部署](./docs/FINAL_DEPLOYMENT_SUMMARY.md)** - 部署总结

---

## 💡 工作流最佳实践

### ✅ 推荐做法

- 💬 在需求文档中清晰描述功能
- 🎯 一个工作流对应一个功能
- 📝 充分利用 AI 的代码审查能力
- 🧪 为重要功能编写测试
- 📊 及时追踪和修复 Bug

### ❌ 避免做法

- 🚫 跳过需求文档直接开发
- 🚫 在一个工作流中做太多功能
- 🚫 忽视代码审查的建议
- 🚫 不测试就合并代码

---

## 🤝 贡献和反馈

### 问题反馈
遇到问题？请：
1. 提交 [Issue](https://github.com/pagges/Stride/issues)

### 功能建议
有想法？欢迎：
1. 提交 [Pull Request](https://github.com/pagges/Stride/pulls)
---

## 🔐 安全性

- ✅ 开源代码，完全透明
- ✅ 无需 root 权限
- ✅ 支持离线使用
- ✅ 无外部依赖（除 Git 和 Bash）
- ✅ 代码审查友好

---

## 📝 许可证

MIT License - 参见 [LICENSE](./LICENSE) 文件

---


## 🌟 Star History

如果 Stride 对你有帮助，请给我们一个 Star ⭐

[![Star History Chart](https://api.star-history.com/svg?repos=pagges/Stride&type=Date)](https://star-history.com/#pagges/Stride&Date)

---


## 🎉 快速开始

准备好了？运行一行命令：

```bash
curl -sSL https://github.com/pagges/Stride/raw/main/install.sh | bash
```

**然后在你的项目中开始使用 Stride！** 🚀

---

<div align="center">

**[文档](./docs/) · [示例](./examples/) · [讨论](https://github.com/pagges/Stride/discussions) · [反馈](https://github.com/pagges/Stride/issues)**

Made with ❤️ for developers everywhere

</div>
