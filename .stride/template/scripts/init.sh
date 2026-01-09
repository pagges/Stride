#!/bin/bash

# Stride - 初始化工作流系统到项目

# 已知支持 commands 的 AI Coding 工具配置
# 格式: "名称:目录路径:描述"
KNOWN_TOOLS=(
    "Claude Code:.claude/commands:Anthropic 官方 AI 编码 CLI"
    "Qoder:.qoder/commands:AI 辅助编码工具"
    "Cursor:.cursor/commands:AI 驱动的代码编辑器"
    "Windsurf:.windsurf/commands:Codeium 的 AI 编码工具"
    "Trae:.trae/commands:字节跳动 AI 编码工具"
)

init_workflow() {
    local ai_tool="${1:-auto}"

    print_info "正在初始化 Stride 工作流系统..."
    echo ""

    if [ "$ai_tool" = "auto" ]; then
        select_ai_tools_manually
    else
        setup_tool_by_name "$ai_tool"
    fi

    echo ""
    print_success "初始化完成！"
    echo ""
    show_usage_guide
}

# 显示使用指南
show_usage_guide() {
    print_info "Stride 工作流系统已准备就绪"
    echo ""
    print_info "推荐使用方式："
    echo ""
    echo "  在 AI Coding 工具中输入："
    echo -e "    ${CYAN}/workflow${NC}              # 创建或管理工作流"
    echo ""
    echo "  或使用 Shell 命令："
    echo -e "    ${CYAN}./.stride/template/stride.sh create <工作流名称>${NC}"
    echo ""
    print_info "可用指令："
    echo "  /workflow              - 工作流管理"
    echo "  /dev <task-id>         - 开发任务"
    echo "  /doc-review            - 文档审查"
    echo "  /code-review           - 代码审查"
    echo "  /bug / /fix <bug-id>   - 问题管理"
    echo "  /test                  - 执行测试"
    echo ""
    print_info "工作流存储位置: .stride/stride-<名称>/"
    echo ""
}

# 手动选择 AI 工具（支持多选）
select_ai_tools_manually() {
    echo "请选择你使用的 AI Coding 工具（可多选，用空格分隔）:"
    echo ""

    local index=1
    for tool_info in "${KNOWN_TOOLS[@]}"; do
        local name="${tool_info%%:*}"
        local rest="${tool_info#*:}"
        local desc="${rest#*:}"
        printf "  %d) %-15s - %s\n" "$index" "$name" "$desc"
        ((index++))
    done
    echo ""
    echo "  C) 自定义路径     - 指定其他工具的 commands 目录"
    echo ""

    read -p "请输入选项 (如: 1 2 或 1 C): " -a choices
    echo ""

    if [ ${#choices[@]} -eq 0 ]; then
        print_warning "未选择任何工具，请手动配置"
        return
    fi

    for choice in "${choices[@]}"; do
        case "$choice" in
            [1-9])
                local idx=$((choice - 1))
                if [ $idx -lt ${#KNOWN_TOOLS[@]} ]; then
                    local tool_info="${KNOWN_TOOLS[$idx]}"
                    local name="${tool_info%%:*}"
                    local rest="${tool_info#*:}"
                    local cmd_dir="${rest%%:*}"
                    setup_tool "$name" "$cmd_dir"
                fi
                ;;
            [Cc])
                setup_custom_tool
                ;;
            *)
                print_warning "忽略无效选项: $choice"
                ;;
        esac
    done
}

# 根据名称设置工具
setup_tool_by_name() {
    local tool_name="$1"

    for tool_info in "${KNOWN_TOOLS[@]}"; do
        local name="${tool_info%%:*}"
        local rest="${tool_info#*:}"
        local cmd_dir="${rest%%:*}"

        if [[ "${name,,}" == "${tool_name,,}" ]] || [[ "${name// /}" == "${tool_name}" ]]; then
            setup_tool "$name" "$cmd_dir"
            return
        fi
    done

    print_warning "未找到工具: $tool_name"
}

# 设置自定义工具
setup_custom_tool() {
    echo ""
    read -p "请输入 commands 目录路径 (如: .mytool/commands): " custom_path

    if [ -z "$custom_path" ]; then
        print_warning "路径为空，跳过"
        return
    fi

    local tool_name="${custom_path%%/*}"
    tool_name="${tool_name#.}"

    setup_tool "$tool_name" "$custom_path"
}

# 通用工具设置函数
setup_tool() {
    local name="$1"
    local cmd_dir="$2"

    print_info "配置 $name..."

    mkdir -p "$cmd_dir"
    create_commands "$cmd_dir"

    print_success "$name 指令已配置到 $cmd_dir/"
}

# 创建指令文件（通用）
create_commands() {
    local cmd_dir="$1"

    # workflow 指令
    cat > "$cmd_dir/workflow.md" << 'EOF'
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
- 必须在工作流目录（.stride/stride-*）内执行，或指定工作流
- 开发完成后会自动更新任务状态
EOF

    # doc-review 指令
    cat > "$cmd_dir/doc-review.md" << 'EOF'
# /doc-review - 文档审查

审查需求文档或设计文档的完整性、清晰度和可行性。

## 使用方法
在工作流目录中执行，或指定文档路径：
```
/doc-review
/doc-review .stride/stride-xxx/Requirements.md
```
EOF

    # code-review 指令
    cat > "$cmd_dir/code-review.md" << 'EOF'
# /code-review - 代码审查

对当前工作流中的代码进行审查，检查代码质量、安全性和最佳实践。
EOF

    # bug 指令
    cat > "$cmd_dir/bug.md" << 'EOF'
# /bug - 提交 Bug

记录发现的问题到工作流的 BugList.md。
EOF

    # fix 指令
    cat > "$cmd_dir/fix.md" << 'EOF'
# /fix - 修复 Bug

修复 BugList.md 中的指定 Bug。
EOF

    # test 指令
    cat > "$cmd_dir/test.md" << 'EOF'
# /test - 执行测试

运行测试并更新测试结果到 TestCase.md。
EOF
}
