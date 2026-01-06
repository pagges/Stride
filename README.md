# Stride

> **S**tructure **T**ask **R**eview **I**terate **D**eploy **E**xecute
>
> AI-Assisted Development Workflow System - 一行命令启动智能开发工作流

[English](./README-EN.md) | 中文

---

## 🚀 快速开始

在你的项目目录运行一行命令：

```bash
curl -sSL https://github.com/your-org/stride/raw/main/install.sh | bash
```

就这样！系统会自动：
- ✅ 检查你的环境
- ✅ 克隆工作流系统
- ✅ 初始化 AI 工具集成
- ✅ 为你准备第一个工作流

---

## 📋 Stride 是什么？

**Stride** 是一个 Shell 脚本工作流系统，帮助团队利用 AI 工具（Claude Code、Cursor 等）进行**结构化、高效的软件开发**。

### 核心特点

| 特点 | 说明 |
|------|------|
| 🤖 **AI 驱动** | 集成 Claude Code、Cursor 等 AI 编码工具 |
| 📐 **结构化** | 从需求→设计→任务→代码→测试，完整流程 |
| 🔄 **迭代友好** | 内置代码审查、问题追踪、bug 修复流程 |
| ⚡ **开箱即用** | 一行命令安装，自动初始化和配置 |
| 🌍 **跨平台** | 支持 macOS、Linux、Windows（WSL） |
| 📚 **完整文档** | 详细的使用指南和最佳实践 |

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

### 创建和管理工作流

```bash
# 创建工作流
./ai-workflow-system/ai-workflow.sh create my-feature

# 查看所有工作流
./ai-workflow-system/ai-workflow.sh workflow

# 显示帮助
./ai-workflow-system/ai-workflow.sh help
```

### 在 AI 工具中使用（推荐）

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
├── ai-workflow-system/        # 核心工作流系统
│   ├── ai-workflow.sh         # 主启动脚本
│   ├── scripts/               # 执行脚本
│   ├── commands/              # AI 工具命令定义
│   └── templates/             # 文档模板
│
├── setup-workflow.sh          # 本地安装脚本
├── install.sh                 # 远程安装脚本（curl）
├── configure-install.sh       # 配置助手脚本
│
├── docs/                      # 文档
│   ├── QUICK_START.md         # 快速开始
│   ├── TEAM_GUIDE.md          # 团队指南
│   ├── DEPLOYMENT.md          # 部署说明
│   └── ...
│
└── README.md                  # 此文件
```

初始化后，你的项目会有：

```
your-project/
├── Stride/                    # 工作流系统（本文件夹）
├── .claude/commands/          # Claude Code 集成
├── ai-workflow/               # 系统配置
└── ai-workflow-<name>/        # 你的工作流项目
    ├── Workflow.md            # 工作流状态
    ├── Requirements.md        # 需求文档
    ├── Design.md              # 设计文档
    ├── Task.md                # 任务分解
    ├── BugList.md             # 问题追踪
    └── TestCase.md            # 测试用例
```

---

## 🛠️ 部署方式

### 方式 1：本地安装（已有项目）

```bash
bash setup-workflow.sh
```

### 方式 2：远程一行安装（推荐）

```bash
curl -sSL https://github.com/your-org/stride/raw/main/install.sh | bash
```

### 方式 3：自动配置

```bash
bash configure-install.sh --auto
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
1. 查看 [常见问题](./docs/QUICK_START.md#-常见问题)
2. 检查相关文档
3. 提交 [Issue](https://github.com/your-org/stride/issues)

### 功能建议

有想法？欢迎：
1. 在 [Discussions](https://github.com/your-org/stride/discussions) 中讨论
2. 提交 [Pull Request](https://github.com/your-org/stride/pulls)
3. 发送邮件给维护团队

---

## 📊 性能和统计

| 指标 | 数值 |
|------|------|
| 安装时间 | < 2 分钟 |
| 创建工作流 | < 1 分钟 |
| 脚本总大小 | ~ 55 KB |
| 支持的 AI 工具 | 3+ |
| 文档页数 | 5+ |

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

## 🎓 学习资源

- 📖 [文档中心](./docs/)
- 🎥 [视频教程](https://example.com/tutorials)
- 💻 [示例项目](./examples/)
- 👥 [社区讨论](https://github.com/your-org/stride/discussions)

---

## 🌟 Star History

如果 Stride 对你有帮助，请给我们一个 Star ⭐

[![Star History Chart](https://api.star-history.com/svg?repos=your-org/stride&type=Date)](https://star-history.com/#your-org/stride&Date)

---

## 📞 联系我们

- 📧 Email: team@example.com
- 💬 Slack: [Join Community](https://example.com/slack)
- 🐦 Twitter: [@stride_dev](https://twitter.com/stride_dev)
- 🌐 Website: [stride.dev](https://stride.dev)

---

## 🎉 快速开始

准备好了？运行一行命令：

```bash
curl -sSL https://github.com/your-org/stride/raw/main/install.sh | bash
```

**然后在你的项目中开始使用 Stride！** 🚀

---

<div align="center">

**[文档](./docs/) · [示例](./examples/) · [讨论](https://github.com/your-org/stride/discussions) · [反馈](https://github.com/your-org/stride/issues)**

Made with ❤️ for developers everywhere

</div>
