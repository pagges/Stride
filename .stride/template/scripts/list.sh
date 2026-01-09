#!/bin/bash

# Stride - 列出所有工作流

list_workflows() {
    local workflows=()
    local count=0
    local stride_dir=".stride"

    print_info "扫描工作流目录..."
    echo ""

    # 检查 .stride 目录是否存在
    if [ ! -d "$stride_dir" ]; then
        print_warning "未找到 .stride 目录"
        echo ""
        print_info "创建新工作流:"
        echo "  ./.stride/template/stride.sh create <工作流名称>"
        echo ""
        echo "或在 AI 编码工具中使用:"
        echo "  /workflow"
        return 0
    fi

    # 查找所有 stride-* 目录
    for dir in "$stride_dir"/stride-*/; do
        if [ -d "$dir" ]; then
            workflows+=("$dir")
            ((count++))
        fi
    done

    if [ $count -eq 0 ]; then
        print_warning "未找到任何工作流"
        echo ""
        print_info "创建新工作流:"
        echo "  ./.stride/template/stride.sh create <工作流名称>"
        echo ""
        echo "或在 AI 编码工具中使用:"
        echo "  /workflow"
        return 0
    fi

    echo "======================================"
    echo "工作流列表 (共 $count 个)"
    echo "======================================"
    echo ""

    local index=1
    for dir in "${workflows[@]}"; do
        local name="${dir%/}"
        name="${name##*/}"  # 获取目录名
        local display_name="${name#stride-}"
        local status="unknown"

        # 尝试读取状态
        if [ -f "${dir}Workflow.md" ]; then
            # 从 YAML frontmatter 提取状态
            status=$(grep -m1 "^status:" "${dir}Workflow.md" 2>/dev/null | awk '{print $2}' || echo "unknown")
        fi

        printf "  %d. %-30s [%s]\n" "$index" "$display_name" "$status"
        ((index++))
    done

    echo ""
    print_info "操作:"
    echo "  查看状态:   ./.stride/template/stride.sh status"
    echo "  创建新的:   ./.stride/template/stride.sh create <名称>"
    echo ""
}
