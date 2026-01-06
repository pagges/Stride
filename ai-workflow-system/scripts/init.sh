#!/bin/bash

# 初始化工作流系统到项目

init_workflow() {
    print_info "正在初始化 AI 工作流指令系统..."
    echo ""

    # 让用户选择 AI 工具
    print_info "选择 AI 编码工具..."
    echo ""
    select_ai_tool_manually

    echo ""
    print_success "✨ 初始化完成！"
    echo ""
    print_info "AI 工具指令已配置完成"
    echo ""
    print_info "下一步操作："
    echo "  创建工作流: $SCRIPT_DIR/ai-workflow.sh create <name>"
    echo ""
    print_info "示例："
    echo "  $SCRIPT_DIR/ai-workflow.sh create 用户认证功能"
    echo ""
}

# 初始化 Claude Code
init_claude_code() {
    print_info "配置 Claude Code 指令..."

    mkdir -p .claude/commands

    # 创建指令定义文件
    create_claude_commands

    print_success "Claude Code 指令已配置到 .claude/commands/"
}

# 初始化 Qoder
init_qoder() {
    print_info "配置 Qoder 指令..."

    mkdir -p .qoder/commands

    # 创建指令定义文件
    create_qoder_commands

    print_success "Qoder 指令已配置到 .qoder/commands/"
}

# 初始化 Cursor
init_cursor() {
    print_info "配置 Cursor..."

    # Cursor 可能使用不同的配置方式
    print_warning "Cursor 配置方式待实现"
    print_info "请手动配置或使用通用的 shell 脚本"
}

# 手动选择 AI 工具
select_ai_tool_manually() {
    echo "请选择你正在使用的 AI 编码工具:"
    echo ""
    echo "  1) Claude Code   - Anthropic 的 AI 编码 CLI 工具"
    echo "  2) Qoder         - AI 辅助编码工具"
    echo "  3) Cursor        - AI 驱动的代码编辑器"
    echo "  4) 其他          - 仅使用 shell 脚本，不配置 AI 工具集成"
    echo ""
    read -p "请输入选项 [1-4]: " choice

    echo ""
    case "$choice" in
        1)
            print_info "正在配置 Claude Code..."
            mkdir -p .claude
            init_claude_code
            ;;
        2)
            print_info "正在配置 Qoder..."
            mkdir -p .qoder
            init_qoder
            ;;
        3)
            print_info "正在配置 Cursor..."
            mkdir -p .cursor
            init_cursor
            ;;
        4)
            print_info "仅使用 shell 脚本模式"
            print_warning "你需要手动执行工作流命令（如: ai-workflow.sh workflow）"
            ;;
        *)
            print_error "无效选项，仅创建基础配置"
            ;;
    esac
}

# 创建 Claude Code 指令
create_claude_commands() {
    # workflow 指令
    cat > .claude/commands/workflow.md << 'EOF'
# /workflow - 工作流管理

## 执行步骤

### 1. 检测当前是否在工作流目录中
```bash
# 使用 Bash 工具检查当前目录名称
basename $(pwd)
```
- 如果目录名以 `ai-workflow-` 开头，说明在工作流中 → 执行步骤 2
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
# 使用 Glob 工具查找工作流目录（正确方法！）
Glob: ai-workflow-*/Workflow.md
```

如果找到工作流：
- 列出所有工作流目录
- 询问用户：创建新工作流 或 选择已有工作流
- 如果选择已有工作流，提示用户切换目录

如果没有工作流：
- 询问用户是否创建新工作流
- 如果是，询问工作流名称并创建

### 4. 创建新工作流
执行 shell 命令：
```bash
# 找到 ai-workflow-system 目录的路径，然后运行
./ai-workflow-system/ai-workflow.sh create <工作流名称>
```
或者从 ai-workflow-system 目录运行：
```bash
./ai-workflow.sh create <工作流名称>
```

## 重要提示
- **查找目录时必须使用 Glob 工具**，不要使用 Search 或 Grep
- **Glob 示例**: `Glob(pattern: "ai-workflow-*/Workflow.md")`
- 工作流目录格式: `ai-workflow-<名称>`
EOF

    # dev 指令
    cat > .claude/commands/dev.md << 'EOF'
# /dev - 开发任务

## 描述
执行开发任务，自动进行代码审查。

## 使用方法
```
/dev TASK-001          # 开发指定任务
/dev                   # 列出待开发任务供选择
```

## 功能
1. 读取任务信息（Requirements.md、Design.md、Task.md）
2. 执行开发实现
3. 自动触发代码审查
4. 更新任务状态到 Task.md

## 注意事项
- 必须在工作流目录（ai-workflow-*）内执行
- 开发完成后会自动更新任务状态
EOF

    # 其他指令
    cat > .claude/commands/doc-review.md << 'EOF'
# /doc-review - 文档审查

审查需求文档或设计文档的完整性、清晰度和可行性。
EOF

    cat > .claude/commands/code-review.md << 'EOF'
# /code-review - 代码审查

对当前工作流中的代码进行审查，检查代码质量、安全性和最佳实践。
EOF

    cat > .claude/commands/bug.md << 'EOF'
# /bug - 提交 Bug

记录发现的问题到 BugList.md。
EOF

    cat > .claude/commands/fix.md << 'EOF'
# /fix - 修复 Bug

修复 BugList.md 中的指定 Bug。
EOF

    cat > .claude/commands/test.md << 'EOF'
# /test - 执行测试

运行测试并更新测试结果到 TestCase.md。
EOF
}

# 创建 Qoder 指令
create_qoder_commands() {
    # Qoder 使用类似的格式，创建相同的指令文件
    local cmd_dir=".qoder/commands"

    # workflow 指令
    cat > "$cmd_dir/workflow.md" << 'EOF'
# /workflow - 工作流管理

## 执行步骤

### 1. 检测当前是否在工作流目录中
```bash
# 使用 Bash 工具检查当前目录名称
basename $(pwd)
```
- 如果目录名以 `ai-workflow-` 开头，说明在工作流中 → 执行步骤 2
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
# 使用 Glob 工具查找工作流目录（正确方法！）
Glob: ai-workflow-*/Workflow.md
```

如果找到工作流：
- 列出所有工作流目录
- 询问用户：创建新工作流 或 选择已有工作流
- 如果选择已有工作流，提示用户切换目录

如果没有工作流：
- 询问用户是否创建新工作流
- 如果是，询问工作流名称并创建

### 4. 创建新工作流
执行 shell 命令：
```bash
# 找到 ai-workflow-system 目录的路径，然后运行
./ai-workflow-system/ai-workflow.sh create <工作流名称>
```
或者从 ai-workflow-system 目录运行：
```bash
./ai-workflow.sh create <工作流名称>
```

## 重要提示
- **查找目录时必须使用 Glob 工具**，不要使用 Search 或 Grep
- **Glob 示例**: `Glob(pattern: "ai-workflow-*/Workflow.md")`
- 工作流目录格式: `ai-workflow-<名称>`
EOF

    # dev 指令
    cat > "$cmd_dir/dev.md" << 'EOF'
# /dev - 开发任务

## 描述
执行开发任务，自动进行代码审查。

## 使用方法
```
/dev TASK-001          # 开发指定任务
/dev                   # 列出待开发任务供选择
```

## 功能
1. 读取任务信息（Requirements.md、Design.md、Task.md）
2. 执行开发实现
3. 自动触发代码审查
4. 更新任务状态到 Task.md

## 注意事项
- 必须在工作流目录（ai-workflow-*）内执行
- 开发完成后会自动更新任务状态
EOF

    # 其他指令
    cat > "$cmd_dir/doc-review.md" << 'EOF'
# /doc-review - 文档审查

审查需求文档或设计文档的完整性、清晰度和可行性。
EOF

    cat > "$cmd_dir/code-review.md" << 'EOF'
# /code-review - 代码审查

对当前工作流中的代码进行审查，检查代码质量、安全性和最佳实践。
EOF

    cat > "$cmd_dir/bug.md" << 'EOF'
# /bug - 提交 Bug

记录发现的问题到 BugList.md。
EOF

    cat > "$cmd_dir/fix.md" << 'EOF'
# /fix - 修复 Bug

修复 BugList.md 中的指定 Bug。
EOF

    cat > "$cmd_dir/test.md" << 'EOF'
# /test - 执行测试

运行测试并更新测试结果到 TestCase.md。
EOF
}

# 创建项目 README
create_project_readme() {
    cat > ai-workflow/README.md << 'EOF'
# AI 开发工作流系统

本项目已集成 AI 开发工作流系统，用于管理开发过程的完整生命周期。

## 快速开始

### 创建工作流
```bash
# 使用 shell 脚本
./path/to/ai-workflow.sh create my-feature

# 或使用 AI 工具指令（如 Claude Code）
/workflow
```

### 核心指令

| 指令 | 功能 | 使用示例 |
|------|------|----------|
| `/workflow` | 工作流管理 | `/workflow` |
| `/dev` | 开发任务 | `/dev TASK-001` |
| `/doc-review` | 文档审查 | `/doc-review Requirements.md` |
| `/code-review` | 代码审查 | `/code-review` |
| `/bug` | 提交问题 | `/bug` |
| `/fix` | 修复问题 | `/fix BUG-001` |
| `/test` | 执行测试 | `/test` |

## 目录说明

- `commands/` - 指令描述文档（供 AI 阅读）
- `templates/` - 文档模板
- `INSTRUCTIONS.md` - AI 执行规范（重要！）

## 工作流程

1. **需求** → 编写 Requirements.md
2. **设计** → 编写 Design.md
3. **任务** → 拆分到 Task.md
4. **开发** → 使用 /dev 执行任务
5. **测试** → 使用 /test 验证

## 更多信息

查看 ai-workflow-system 项目文档获取完整说明。
EOF
}
