# AI 开发工作流系统 - Shell 工程使用指南

这是一个可执行的 Shell 工程，可以初始化工作流系统到任何项目中，并集成到各种 AI coding 工具。

## 快速开始

### 1. 克隆或下载本项目

```bash
git clone https://github.com/pagges/Stride/ai-workflow-system.git
# 或直接下载并解压
```

### 2. 进入你的项目目录

```bash
cd /path/to/your/project
```

### 3. 初始化工作流系统

```bash
/path/to/ai-workflow-system/ai-workflow.sh init
```

这个命令会：
- 创建 `ai-workflow/` 目录
- 复制所有指令描述文档到 `ai-workflow/commands/`
- 检测你使用的 AI 工具（Claude Code / Qoder / Cursor）
- 将指令定义复制到对应的目录：
  - Claude Code: `.claude/commands/`
  - Qoder: `.qoder/commands/`
- 复制文档模板和执行规范

### 4. 创建第一个工作流

```bash
/path/to/ai-workflow-system/ai-workflow.sh create my-feature
```

或使用 AI 工具的指令系统：

```
/workflow
```

## 系统架构

```
你的项目/
├── .claude/commands/          # Claude Code 指令（自动生成）
│   ├── workflow.md
│   ├── dev.md
│   └── ...
├── .qoder/commands/           # Qoder 指令（自动生成）
│   └── ...
├── ai-workflow/               # 工作流系统配置
│   ├── commands/              # 指令描述（供 AI 阅读）
│   ├── templates/             # 文档模板
│   ├── INSTRUCTIONS.md        # AI 执行规范
│   └── README.md              # 使用说明
└── ai-workflow-my-feature/    # 你的工作流项目
    ├── Workflow.md
    ├── Requirements.md
    ├── Design.md
    ├── Task.md
    ├── BugList.md
    └── TestCase.md
```

## 可用命令

### Shell 脚本命令

所有命令格式：`/path/to/ai-workflow-system/ai-workflow.sh <command> [options]`

| 命令 | 功能 | 示例 |
|------|------|------|
| `init` | 初始化工作流系统到当前项目 | `./ai-workflow.sh init` |
| `create <name>` | 创建新工作流 | `./ai-workflow.sh create user-auth` |
| `workflow` | 查看工作流状态 | `./ai-workflow.sh workflow` |
| `help` | 显示帮助信息 | `./ai-workflow.sh help` |

### AI 工具指令

初始化后，可以在 AI 工具中直接使用：

| 指令 | 功能 |
|------|------|
| `/workflow` | 工作流管理（创建/进入/查看状态） |
| `/dev <task-id>` | 开发任务 |
| `/doc-review [file]` | 文档审查 |
| `/code-review` | 代码审查 |
| `/bug` | 提交问题 |
| `/fix <bug-id>` | 修复问题 |
| `/test` | 执行测试 |

## 使用流程

### 方式 1：纯 Shell 脚本模式

```bash
# 1. 初始化
./ai-workflow.sh init

# 2. 创建工作流
./ai-workflow.sh create user-auth

# 3. 进入工作流目录
cd ai-workflow-user-auth

# 4. 编辑需求文档
vim Requirements.md

# 5. 使用 AI 工具继续后续流程
# 在 AI 工具中输入 /workflow
```

### 方式 2：AI 工具集成模式（推荐）

```bash
# 1. 初始化（仅一次）
./ai-workflow.sh init

# 2-7. 在 AI 工具中使用指令
# 在 Claude Code / Qoder 中直接输入：

/workflow                  # 创建或进入工作流
# [提供需求描述]
/doc-review               # AI 自动审查需求文档
/dev TASK-001             # AI 执行开发任务
/code-review              # AI 审查代码
/test                     # AI 执行测试
```

## 支持的 AI 工具

### Claude Code

初始化后，指令会自动配置到 `.claude/commands/`。

在 Claude Code 中直接输入 `/workflow`、`/dev` 等指令即可使用。

### Qoder

初始化后，指令会自动配置到 `.qoder/commands/`。

在 Qoder 中直接输入相应指令即可使用。

### Cursor

Cursor 支持正在开发中。目前可以：
1. 使用 Shell 脚本创建工作流
2. 手动将 `ai-workflow/INSTRUCTIONS.md` 提供给 Cursor 阅读
3. 手动输入指令（如 "请执行 /workflow"）

### 其他 AI 工具

对于其他 AI 编码工具：
1. 使用 Shell 脚本创建和管理工作流
2. 将 `ai-workflow/INSTRUCTIONS.md` 提供给 AI 阅读
3. 手动输入指令让 AI 按规范执行

## 目录说明

### ai-workflow-system（本项目）

- `ai-workflow.sh` - 主启动脚本
- `scripts/` - 功能脚本
  - `init.sh` - 初始化脚本
  - `create-workflow.sh` - 创建工作流
  - `workflow.sh` - workflow 命令实现
  - `utils.sh` - 工具函数
- `commands/` - 指令描述文档（供 AI 阅读）
- `templates/` - 文档模板
- `INSTRUCTIONS.md` - AI 执行规范（核心文件）
- `USER_GUIDE.md` - 用户使用手册
- `examples/` - 完整示例

### 初始化后的项目

- `ai-workflow/` - 工作流系统配置（复制自本项目）
- `.claude/commands/` - Claude Code 指令（如果检测到）
- `.qoder/commands/` - Qoder 指令（如果检测到）
- `ai-workflow-*/` - 你创建的工作流项目

## 常见问题

### Q: 如何切换到其他项目使用？

A: 在新项目目录中重新执行 `./ai-workflow.sh init` 即可。

### Q: 可以同时管理多个工作流吗？

A: 可以。每个 `ai-workflow-*` 文件夹都是独立的工作流。

### Q: 如何更新工作流系统？

A:
1. 更新 `ai-workflow-system` 项目
2. 在你的项目中重新执行 `./ai-workflow.sh init`
3. 选择覆盖现有配置

### Q: Shell 脚本无法执行怎么办？

A: 添加执行权限：
```bash
chmod +x /path/to/ai-workflow-system/ai-workflow.sh
chmod +x /path/to/ai-workflow-system/scripts/*.sh
```

### Q: AI 工具没有正确执行指令？

A:
1. 确保已执行 `./ai-workflow.sh init`
2. 检查对应的 commands 目录是否存在
3. 让 AI 重新阅读 `ai-workflow/INSTRUCTIONS.md`

## 高级用法

### 自定义指令

1. 编辑 `ai-workflow/commands/<指令名>.md`
2. 修改 `ai-workflow/INSTRUCTIONS.md` 添加执行规范
3. 重新初始化或手动复制到 AI 工具目录

### 自定义模板

1. 编辑 `ai-workflow/templates/*.template`
2. 新创建的工作流会使用新模板

### 集成到 CI/CD

可以在 CI/CD 流程中使用 shell 脚本：

```yaml
# .github/workflows/check.yml
- name: Check workflow status
  run: |
    cd ai-workflow-my-feature
    ../ai-workflow-system/ai-workflow.sh workflow
```

## 示例

查看 `examples/ai-workflow-user-auth/` 目录，这是一个完整的用户认证系统工作流示例，展示了从需求到测试的完整流程。

## 贡献

欢迎提交 Issue 和 Pull Request！

## 许可证

MIT License
