#!/bin/bash

# Stride - 显示工作流状态

show_status() {
    local workflow_dir=""
    local stride_dir=".stride"

    # 检查是否在工作流目录中（.stride/stride-xxx）
    local current_dir=$(basename "$(pwd)")
    local parent_dir=$(basename "$(dirname "$(pwd)")")

    if [[ "$current_dir" == stride-* ]] && [[ "$parent_dir" == ".stride" ]]; then
        workflow_dir="."
    else
        # 检查 .stride 目录是否存在
        if [ ! -d "$stride_dir" ]; then
            print_warning "未找到 .stride 目录"
            echo ""
            print_info "请先创建工作流:"
            echo "  ./.stride/template/stride.sh create <工作流名称>"
            return 1
        fi

        # 尝试查找工作流目录
        local found=()
        for dir in "$stride_dir"/stride-*/; do
            if [ -d "$dir" ]; then
                found+=("$dir")
            fi
        done

        if [ ${#found[@]} -eq 0 ]; then
            print_warning "未找到任何工作流"
            echo ""
            print_info "请先创建工作流:"
            echo "  ./.stride/template/stride.sh create <工作流名称>"
            return 1
        elif [ ${#found[@]} -eq 1 ]; then
            workflow_dir="${found[0]}"
        else
            print_info "发现多个工作流，请指定:"
            echo ""
            local index=1
            for dir in "${found[@]}"; do
                local name="${dir%/}"
                name="${name##*/}"
                echo "  $index. ${name#stride-}"
                ((index++))
            done
            echo ""
            print_info "使用 'list' 查看详情，或进入工作流目录后运行此命令"
            return 1
        fi
    fi

    # 显示状态
    display_workflow_status "$workflow_dir"
}

display_workflow_status() {
    local dir="$1"
    local workflow_file="${dir}/Workflow.md"

    if [ ! -f "$workflow_file" ]; then
        print_error "找不到 Workflow.md 文件"
        return 1
    fi

    # 提取信息
    local name=$(grep -m1 "^name:" "$workflow_file" 2>/dev/null | sed 's/name: *//' || echo "未知")
    local status=$(grep -m1 "^status:" "$workflow_file" 2>/dev/null | sed 's/status: *//' || echo "unknown")
    local created=$(grep -m1 "^created_at:" "$workflow_file" 2>/dev/null | sed 's/created_at: *//' || echo "-")

    echo ""
    echo "======================================"
    echo "工作流: $name"
    echo "======================================"
    echo ""

    # 状态映射
    local status_display=""
    case "$status" in
        planning|requirements)
            status_display="需求分析"
            ;;
        design)
            status_display="系统设计"
            ;;
        implementation)
            status_display="代码实现"
            ;;
        testing)
            status_display="测试验收"
            ;;
        deployment|completed)
            status_display="上线部署"
            ;;
        *)
            status_display="$status"
            ;;
    esac

    echo "【基本信息】"
    echo "  当前阶段: $status_display"
    echo "  创建时间: $created"
    echo "  工作目录: $(cd "$dir" && pwd)"
    echo ""

    # 显示阶段进度
    echo "【阶段进度】"

    local stages=("requirements:需求分析" "design:系统设计" "implementation:代码实现" "testing:测试验收" "deployment:上线部署")

    for stage_info in "${stages[@]}"; do
        local stage_key="${stage_info%%:*}"
        local stage_name="${stage_info##*:}"
        local stage_status=$(grep -A1 "  $stage_key:" "$workflow_file" 2>/dev/null | grep "status:" | sed 's/.*status: *//' | tr -d '{}' || echo "not_started")

        local icon="○"
        case "$stage_status" in
            completed)
                icon="✓"
                ;;
            in_progress)
                icon="●"
                ;;
            *)
                icon="○"
                ;;
        esac

        printf "  %s %-12s\n" "$icon" "$stage_name"
    done
    echo ""

    # 显示文档状态
    echo "【文档状态】"
    local docs=("Requirements.md:需求文档" "Design.md:设计文档" "Task.md:任务清单" "BugList.md:Bug列表" "TestCase.md:测试用例")

    for doc_info in "${docs[@]}"; do
        local doc_file="${doc_info%%:*}"
        local doc_name="${doc_info##*:}"

        if [ -f "${dir}/${doc_file}" ]; then
            local size=$(wc -l < "${dir}/${doc_file}" 2>/dev/null || echo "0")
            if [ "$size" -gt 20 ]; then
                printf "  ✓ %-15s (已编写)\n" "$doc_name"
            else
                printf "  ○ %-15s (待完善)\n" "$doc_name"
            fi
        else
            printf "  ✗ %-15s (不存在)\n" "$doc_name"
        fi
    done
    echo ""

    # 下一步建议
    echo "【下一步】"
    case "$status" in
        planning|requirements)
            echo "  1. 编写 Requirements.md 需求文档"
            echo "  2. 执行 /doc-review 审查需求"
            ;;
        design)
            echo "  1. 编写 Design.md 设计文档"
            echo "  2. 执行 /doc-review 审查设计"
            ;;
        implementation)
            echo "  1. 查看 Task.md 中的任务"
            echo "  2. 执行 /dev TASK-001 开发任务"
            ;;
        testing)
            echo "  1. 执行 /test 运行测试"
            echo "  2. 使用 /bug 记录问题"
            ;;
        *)
            echo "  使用 /workflow 查看更多信息"
            ;;
    esac
    echo ""
}
