# AI 工作流系统 - 快速开始指南

> 一行命令快速安装，零配置开箱即用

## 🚀 快速安装（一行命令）

### ⚡ 快速初始化（推荐）

在你的项目根目录，运行一行命令完成全部初始化：

```bash
curl -sSL https://github.com/pagges/Stride/raw/main/install.sh | bash
```

或使用 wget：

```bash
wget -qO- https://github.com/pagges/Stride/raw/main/install.sh | bash
```

**优点：**
- 💨 超快速：一行命令完成全部安装和初始化
- 📦 零依赖：无需下载任何文件
- 🔄 自动更新：每次安装都是最新版本
- 👥 完美分享：只需分享这一个命令给团队

**需要的前置条件：**
- ✅ 已安装 Git
- ✅ 已安装 curl 或 wget
- ✅ 有网络连接

---

### 备选方案 1：本地安装

如果你已经有项目目录，可以使用本地脚本：

```bash
cd your-project
bash setup-workflow.sh
```

---

### 备选方案 2：手动安装

```bash
# 1. 克隆工作流系统
git clone https://github.com/pagges/Stride.git

# 2. 进入你的项目
cd your-project

# 3. 运行初始化
../Stride/install.sh

# 4. 创建第一个工作流
../Stride/ai-workflow-system/ai-workflow.sh create 功能名称
```

---

## ✨ 安装完成后

### 查看状态
```bash
./Stride/ai-workflow-system/ai-workflow.sh workflow
```

### 创建工作流
```bash
./Stride/ai-workflow-system/ai-workflow.sh create 用户认证功能
```

### 在 AI 工具中使用

安装后，你可以在 Claude Code / Cursor 等 AI 工具中直接使用：

```
/workflow              # 创建或进入工作流
/dev TASK-001          # 开发任务
/doc-review           # 审查文档
/code-review          # 代码审查
/bug                  # 提交问题
/fix BUG-001          # 修复问题
/test                 # 执行测试
```

---

## 📋 完整工作流

```
1. 创建工作流
   /workflow

2. 编写需求
   Requirements.md

3. AI 审查需求
   /doc-review

4. 生成设计
   Design.md

5. 分解任务
   Task.md

6. AI 开发
   /dev TASK-001

7. 代码审查
   /code-review

8. 测试
   /test

9. 修复问题（如需）
   /bug / /fix
```

---

## 🆘 常见问题

### Q: 如何团队共享这个系统？

A: 只需分享这个命令给团队成员：

```bash
curl -sSL https://github.com/pagges/Stride/raw/main/install.sh | bash
```

或分享这个链接：
```
https://github.com/pagges/Stride#快速开始
```

---

### Q: 多个项目可以用同一个系统吗？

A: 可以。每个项目目录中都运行安装命令即可，每个项目独立管理。

```bash
# 项目 A
cd project-a
bash setup-workflow.sh

# 项目 B
cd project-b
bash setup-workflow.sh
```

---

### Q: 如何更新工作流系统？

A: 重新运行安装命令，选择覆盖即可：

```bash
bash setup-workflow.sh
# 当提示覆盖时，选择 y
```

---

### Q: 脚本无法执行怎么办？

A: 添加执行权限：

```bash
chmod +x setup-workflow.sh
chmod +x install.sh
chmod +x ai-workflow-system/ai-workflow.sh
chmod +x ai-workflow-system/scripts/*.sh
```

---

### Q: 网络不好怎么办？

A: 使用本地安装方式：

```bash
# 1. 手动下载或克隆工作流系统
git clone https://github.com/pagges/Stride.git

# 2. 在项目目录初始化
cd your-project
bash ./Stride/install.sh
```

---

### Q: 能删除这些文件吗？

A: 可以，但注意：

- ✅ 可以删除：`setup-workflow.sh`、`install.sh`
- ✅ 可以删除：`.claude/commands/`、`.qoder/commands/`
- ❌ 不要删除：`ai-workflow/` （系统配置）
- ❌ 不要删除：`ai-workflow-*/` （你的工作流项目）

---

## 📚 更多信息

- 📖 详细文档：[README-SHELL.md](./README-SHELL.md)
- 🔗 GitHub 仓库：https://github.com/pagges/Stride
- 💬 问题反馈：https://github.com/pagges/Stride/issues

---

## 🎯 下一步

1. **运行安装命令**（选择上面任意一种）
2. **创建第一个工作流**：`./Stride/ai-workflow-system/ai-workflow.sh create my-feature`
3. **开始开发流程**：在工作流目录中编辑需求文档

祝你使用愉快！ 🚀
