# 🚀 团队工作流系统快速指南

> Stride - AI 开发工作流系统 - 为团队构建高效的开发流程

---

## 📌 给团队成员的安装说明

### 最快方式（推荐！只需一行）

```bash
curl -sSL https://github.com/your-or./Stride/ai-workflow-system/raw/main/install.sh | bash
```

**就这样！** 系统会自动：
- ✅ 检查你的环境
- ✅ 克隆工作流系统
- ✅ 初始化 AI 工具集成
- ✅ 为你准备第一个工作流

> **如果是 macOS/Linux 用户**，可能需要使用 `bash` 命令
>
> **如果是 Windows 用户**，请使用 WSL 或 Git Bash

---

## ⚡ 5 分钟快速上手

### 第 1 步：运行安装命令

```bash
curl -sSL https://github.com/your-or./Stride/ai-workflow-system/raw/main/install.sh | bash
```

### 第 2 步：创建你的第一个工作流

```bash
./Stride/ai-workflow-system/ai-workflow.sh create 我的功能名称
```

例如：
```bash
./Stride/ai-workflow-system/ai-workflow.sh create 用户登录功能
```

### 第 3 步：进入工作流目录

```bash
cd ai-workflow-我的功能名称
```

### 第 4 步：编写需求文档

编辑 `Requirements.md`，描述你的功能需求

### 第 5 步：让 AI 帮你完成

在 Claude Code / Cursor 中输入：
```
/doc-review         # 审查需求
/dev TASK-001       # 开发任务
/code-review        # 代码审查
/test               # 测试
```

**完成！** 🎉

---

## 📁 你会得到什么？

安装后，项目中会有：

```
你的项目/
├── ai-workflow-system/          ← 工作流系统（自动下载）
├── .claude/commands/            ← AI 工具集成（自动配置）
├── ai-workflow/                 ← 系统配置文件
└── ai-workflow-<功能名>/        ← 你的工作流项目
    ├── Workflow.md              ← 工作流状态
    ├── Requirements.md          ← 需求文档
    ├── Design.md                ← 设计文档
    ├── Task.md                  ← 任务分解
    ├── BugList.md               ← 问题追踪
    └── TestCase.md              ← 测试用例
```

---

## 🎯 常用命令速查表

### 工作流管理
```bash
# 创建新工作流
./Stride/ai-workflow-system/ai-workflow.sh create <功能名>

# 查看所有工作流
./Stride/ai-workflow-system/ai-workflow.sh workflow

# 查看帮助
./Stride/ai-workflow-system/ai-workflow.sh help
```

### 在 AI 工具中使用（推荐）

| 命令 | 用途 |
|------|------|
| `/workflow` | 创建或进入工作流 |
| `/dev TASK-001` | 开发任务 |
| `/doc-review` | 审查文档 |
| `/code-review` | 代码审查 |
| `/bug` | 提交问题 |
| `/fix BUG-001` | 修复问题 |
| `/test` | 执行测试 |

---

## 🔄 典型工作流程

```
┌─────────────────────────────────────────────────────────┐
│ 1. 创建工作流                                              │
│    /workflow → 创建新工作流                                │
└─────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────┐
│ 2. 编写需求                                              │
│    编辑 Requirements.md → 描述功能需求                    │
└─────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────┐
│ 3. AI 审查需求                                          │
│    /doc-review → AI 检查文档完整性                       │
└─────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────┐
│ 4. 生成设计                                              │
│    AI 生成 Design.md → 架构和实现方案                    │
└─────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────┐
│ 5. 分解任务                                              │
│    AI 生成 Task.md → 分成具体开发任务                    │
└─────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────┐
│ 6. AI 开发                                               │
│    /dev TASK-001 → AI 根据任务编写代码                  │
└─────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────┐
│ 7. 代码审查                                              │
│    /code-review → AI 审查代码质量                       │
└─────────────────────────────────────────────────────────┘
                        ↓
                    (迭代或继续)
                        ↓
┌─────────────────────────────────────────────────────────┐
│ 8. 测试验证                                              │
│    /test → AI 执行测试用例                              │
└─────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────┐
│ 9. 问题修复（如需）                                      │
│    /bug TASK-001 → 提交问题                             │
│    /fix BUG-001 → AI 修复问题                           │
└─────────────────────────────────────────────────────────┘
                        ↓
                    ✅ 完成！
```

---

## ❓ 常见问题

### 如何删除一个工作流？

```bash
# 找到要删除的工作流目录
rm -rf ai-workflow-功能名称/
```

### 如何在多个项目中使用？

每个项目运行一次安装即可，相互独立：

```bash
# 项目 A
cd project-a
curl -sSL https://github.com/your-or./Stride/ai-workflow-system/raw/main/install.sh | bash

# 项目 B
cd project-b
curl -sSL https://github.com/your-or./Stride/ai-workflow-system/raw/main/install.sh | bash
```

### 出现权限错误怎么办？

```bash
# 添加执行权限
chmod +x ai-workflow-system/ai-workflow.sh
chmod +x ai-workflow-system/scripts/*.sh
```

### 能离线使用吗？

可以，使用本地安装：

```bash
# 1. 找人复制 ai-workflow-system 目录
# 2. 放到你的项目中
# 3. 运行初始化
./Stride/ai-workflow-system/ai-workflow.sh init
```

### AI 工具无法找到命令？

1. 确保已运行 `init` 命令
2. 检查 `.claude/commands/` 目录是否存在
3. 重启 AI 工具
4. 让 AI 重新阅读 `ai-workflow/INSTRUCTIONS.md`

---

## 📚 更多文档

- 📖 **[快速开始](./QUICK_START.md)** - 详细的安装和使用说明
- 🚀 **[部署指南](./DEPLOYMENT.md)** - 如何在不同平台部署
- 📋 **[系统文档](./Stride/ai-workflow-system/README-SHELL.md)** - 完整的技术文档
- 🆘 **[疑难解答](./Stride/ai-workflow-system/README-SHELL.md#常见问题)** - 问题排查

---

## 💡 工作流最佳实践

### ✅ 做这些

- 💬 在 Requirements.md 中写清楚需求
- 🎯 一个工作流对应一个功能
- 📝 经常使用 `/code-review` 审查代码
- 🧪 为重要功能编写测试
- 📊 追踪 BugList.md 中的问题

### ❌ 避免这些

- 🚫 不要在一个工作流中做太多功能
- 🚫 不要跳过需求文档直接开发
- 🚫 不要忽视代码审查的建议
- 🚫 不要不测试就合并代码

---

## 🎓 学习路径

### 第 1 天：基础
1. 安装工作流系统
2. 创建第一个工作流
3. 编写需求文档

### 第 2-3 天：实践
1. 让 AI 审查需求
2. 生成设计和任务
3. 让 AI 开发任务

### 第 4-5 天：优化
1. 使用代码审查
2. 编写测试用例
3. 追踪和修复问题

### 持续改进
1. 分享经验给团队
2. 优化工作流流程
3. 定制模板和命令

---

## 👥 团队协作

### 分享项目

```bash
# 共享你的项目给团队
git push origin main

# 团队成员克隆项目
git clone https://github.com/your-org/project.git
cd project

# 然后运行安装（如果还没装的话）
curl -sSL https://github.com/your-or./Stride/ai-workflow-system/raw/main/install.sh | bash
```

### 同步工作流系统更新

当工作流系统有更新时：

```bash
bash setup-workflow.sh
# 或
curl -sSL https://github.com/your-or./Stride/ai-workflow-system/raw/main/install.sh | bash
```

---

## 🔗 相关链接

- 🌐 **GitHub 仓库**：https://github.com/your-org/ai-workflow-system
- 📧 **反馈邮箱**：team@company.com
- 💬 **讨论区**：https://github.com/your-or./Stride/ai-workflow-system/discussions
- 🐛 **报告问题**：https://github.com/your-or./Stride/ai-workflow-system/issues

---

## 🎉 开始使用

准备好了？运行这一行命令开始吧：

```bash
curl -sSL https://github.com/your-or./Stride/ai-workflow-system/raw/main/install.sh | bash
```

有任何问题，请查看 [快速开始](./QUICK_START.md) 或 [常见问题](#常见问题)。

**祝你编码愉快！** 🚀
