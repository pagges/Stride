# /workflow - 工作流管理

## 执行步骤

### 1. 检测当前是否在工作流目录中
```bash
# 检查当前目录
pwd
# 检查目录名
basename $(pwd)
```
- 如果在 `.stride/stride-*` 目录中，说明在工作流中 → 执行步骤 2
- 否则 → 执行步骤 3

### 2. 显示工作流状态（在工作流中）
```bash
# 读取 Workflow.md 文件
Read: ./Workflow.md
```
显示内容：
- 工作流名称
- 当前阶段
- 各阶段进度
- 建议的下一步操作

### 3. 列出和管理工作流（不在工作流中）
```bash
# 使用 Glob 工具查找工作流目录
Glob: .stride/stride-*/Workflow.md
```

如果找到工作流：
- 列出所有工作流目录
- 询问用户：创建新工作流 或 选择已有工作流
- 如果选择已有工作流，显示其路径

如果没有工作流：
- 询问用户是否创建新工作流
- 如果是，询问工作流名称并创建

### 4. 创建新工作流
执行 shell 命令：
```bash
./.stride/template/stride.sh create <工作流名称>
```

## 重要提示
- **查找目录时必须使用 Glob 工具**，不要使用 Search 或 Grep
- **Glob 示例**: `Glob(pattern: ".stride/stride-*/Workflow.md")`
- 工作流目录格式: `.stride/stride-<名称>`
