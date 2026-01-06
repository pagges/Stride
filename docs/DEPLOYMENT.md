# 工作流系统部署指南

> 如何在不同平台上部署和分享你的 AI 工作流系统

## 📦 部署前准备

### 1. 更新脚本中的仓库地址

所有安装脚本中都有一个默认的仓库地址，需要更新为你的仓库：

**在 `setup-workflow.sh` 中：**
```bash
# 第 76 行（左右）
local repo_url="${1:-https://github.com/your-org/ai-workflow-system.git}"
                                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                                          改为你的仓库地址
```

**在 `install.sh` 中：**
```bash
# 第 54 行（左右）
local base_url="${1:-https://github.com/your-org/ai-workflow-system/raw/main}"
                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                          改为你的仓库地址
```

**在 `README-SHELL.md` 中：**
```bash
# 第 10 行（左右）
git clone https://your-repo/ai-workflow-system.git
                 ^^^^^^^^^^^^
                 改为你的仓库地址
```

### 2. 项目结构

确保你的仓库包含以下文件：

```
ai-workflow-system/
├── ai-workflow.sh           ✅ 主脚本（必需）
├── install.sh              ✅ 远程安装脚本（必需）
├── setup-workflow.sh        ✅ 本地安装脚本（可选）
├── README-SHELL.md         ✅ 详细文档（必需）
├── QUICK_START.md          ✅ 快速开始（可选）
├── DEPLOYMENT.md           ✅ 部署说明（可选）
├── scripts/
│   ├── init.sh             ✅ 初始化脚本（必需）
│   ├── utils.sh            ✅ 工具函数（必需）
│   ├── create-workflow.sh   ✅
│   └── ...
├── commands/
│   ├── workflow.md         ✅ 工作流命令（必需）
│   ├── dev.md
│   ├── code-review.md
│   └── ...
├── templates/
│   ├── Workflow.md.template
│   ├── Requirements.md.template
│   ├── Design.md.template
│   ├── Task.md.template
│   ├── BugList.md.template
│   └── TestCase.md.template
└── .gitignore             ✅ 推荐包含
```

---

## 🚀 GitHub 部署

### 1. 创建仓库

```bash
# 初始化仓库
git init ai-workflow-system
cd ai-workflow-system

# 创建初始提交
git add .
git commit -m "Initial commit: AI workflow system"

# 添加远程仓库
git remote add origin https://github.com/your-username/ai-workflow-system.git

# 推送到主分支
git branch -M main
git push -u origin main
```

### 2. 获取原始文件 URL

GitHub 上的原始文件 URL 格式：
```
https://github.com/<username>/<repo>/raw/<branch>/<file-path>
```

例如：
```
https://github.com/your-org/ai-workflow-system/raw/main/install.sh
```

### 3. 更新脚本中的地址

```bash
# 在脚本中将
https://github.com/your-org/ai-workflow-system/raw/main

# 替换为你的实际地址
https://github.com/your-username/ai-workflow-system/raw/main
```

### 4. 分享给团队

**方式 A：完整教程**
```markdown
# 快速安装

在你的项目目录运行：

\`\`\`bash
curl -sSL https://github.com/your-username/ai-workflow-system/raw/main/install.sh | bash
\`\`\`

或查看完整文档：[快速开始](./QUICK_START.md)
```

**方式 B：简洁链接**
```
一行安装：
curl -sSL https://github.com/your-username/ai-workflow-system/raw/main/install.sh | bash
```

**方式 C：README 中的徽章**
```markdown
[![Install](https://img.shields.io/badge/install-one%20command-brightgreen)](https://github.com/your-username/ai-workflow-system#快速安装)
```

---

## 🏢 GitLab 部署

### 1. 创建仓库

```bash
git remote add origin https://gitlab.com/your-org/ai-workflow-system.git
git branch -M main
git push -u origin main
```

### 2. 获取原始文件 URL

GitLab 上的原始文件 URL 格式：
```
https://gitlab.com/<group>/<project>/-/raw/<branch>/<file-path>
```

例如：
```
https://gitlab.com/your-org/ai-workflow-system/-/raw/main/install.sh
```

### 3. 更新脚本

```bash
# 在 install.sh 中改为
local base_url="${1:-https://gitlab.com/your-org/ai-workflow-system/-/raw/main}"
```

### 4. 分享命令

```bash
curl -sSL https://gitlab.com/your-org/ai-workflow-system/-/raw/main/install.sh | bash
```

---

## 🔧 Gitee（码云）部署

### 1. 创建仓库

```bash
git remote add origin https://gitee.com/your-org/ai-workflow-system.git
git push -u origin main
```

### 2. 获取原始文件 URL

Gitee 上的原始文件 URL 格式：
```
https://gitee.com/<user>/<repo>/raw/<branch>/<file-path>
```

例如：
```
https://gitee.com/your-org/ai-workflow-system/raw/main/install.sh
```

### 3. 更新脚本

```bash
# 在 install.sh 中改为
local base_url="${1:-https://gitee.com/your-org/ai-workflow-system/raw/main}"
```

### 4. 分享命令

```bash
curl -sSL https://gitee.com/your-org/ai-workflow-system/raw/main/install.sh | bash
```

---

## 📊 版本控制和更新

### .gitignore 建议

```
# 临时文件
.DS_Store
*.swp
*.swo
*~

# AI 工具生成的命令
.claude/commands/*
!.claude/.gitkeep
.qoder/commands/*
!.qoder/.gitkeep

# 项目实例（不包含在系统仓库中）
ai-workflow-*/
.claude/
.qoder/
ai-workflow/

# Node（如果使用）
node_modules/
npm-debug.log
```

### 更新现有项目的工作流系统

当你更新了工作流系统时：

```bash
# 1. 推送更新到主分支
git add .
git commit -m "Update: workflow system improvements"
git push origin main

# 2. 通知团队重新运行安装命令
bash setup-workflow.sh
# 或
curl -sSL https://github.com/your-org/ai-workflow-system/raw/main/install.sh | bash
```

---

## ✅ 部署检查清单

在部署前，确保：

- [ ] 更新了脚本中的仓库地址
- [ ] 所有必需文件都已包含
- [ ] 脚本有正确的执行权限（755）
- [ ] 在本地测试过安装流程
- [ ] README 文档已更新
- [ ] 测试了网络安装：`curl -sSL ... | bash`
- [ ] 测试了本地安装：`bash setup-workflow.sh`

---

## 🧪 测试安装

### 在本地测试

```bash
# 创建测试目录
mkdir -p /tmp/workflow-test
cd /tmp/workflow-test
git init

# 测试本地安装
bash /path/to/setup-workflow.sh

# 测试远程安装
curl -sSL https://your-repo/install.sh | bash
```

### 测试检查清单

- [ ] 依赖检查通过
- [ ] 仓库克隆成功
- [ ] 脚本添加了执行权限
- [ ] 初始化完成
- [ ] 命令目录创建成功
- [ ] 没有权限错误

---

## 🔒 安全性考虑

### 1. 脚本安全

在通过 curl 运行远程脚本前，建议：

```bash
# 1. 先下载查看
curl -sSL https://your-repo/install.sh > /tmp/install.sh

# 2. 审查内容
cat /tmp/install.sh

# 3. 再运行
bash /tmp/install.sh
```

### 2. Git 验证

建议对关键版本添加 Git 标签和签名：

```bash
# 创建发布版本
git tag -s v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

### 3. 访问控制

建议：
- ✅ 仓库设为公开（方便团队访问）
- ✅ 主分支添加分支保护规则
- ✅ 要求 Pull Request 审查
- ✅ 定期审计脚本变更

---

## 💬 反馈和支持

- 📧 Email: your-email@company.com
- 🐛 Issue: https://github.com/your-org/ai-workflow-system/issues
- 📖 Wiki: https://github.com/your-org/ai-workflow-system/wiki

---

## 📝 更新日志

### v1.0.0 (2024-01-06)
- ✅ 初始发布
- ✅ 支持 GitHub/GitLab/Gitee
- ✅ 一行安装命令
- ✅ 完整的文档

---

祝部署顺利！如有问题，请参考文档或提交 Issue。🚀
