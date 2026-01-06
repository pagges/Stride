#!/bin/bash

# AI 开发工作流系统 - 工具函数
# 此文件包含共享的工具函数

# 注意：颜色定义和基础打印函数已在 ai-workflow.sh 中定义
# 此文件用于存放额外的共享工具函数

# 检查是否在工作流目录中
is_in_workflow_dir() {
    local dir_name=$(basename "$(pwd)")
    [[ "$dir_name" == ai-workflow-* ]]
}

# 获取工作流名称（从目录名提取）
get_workflow_name() {
    local dir_name=$(basename "$(pwd)")
    echo "${dir_name#ai-workflow-}"
}

# 查找项目根目录（包含 .git 或 CLAUDE.md 的目录）
find_project_root() {
    local current_dir="$(pwd)"
    while [[ "$current_dir" != "/" ]]; do
        if [[ -d "$current_dir/.git" ]] || [[ -f "$current_dir/CLAUDE.md" ]]; then
            echo "$current_dir"
            return 0
        fi
        current_dir="$(dirname "$current_dir")"
    done
    # 如果找不到，返回当前目录
    pwd
}
