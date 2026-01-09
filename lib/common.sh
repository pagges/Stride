#!/bin/bash

# Stride - 共享工具函数库
# 此文件包含所有脚本共用的颜色定义和打印函数

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 打印函数
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_header() {
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# 安全的 sed 替换函数（转义特殊字符）
safe_sed_replace() {
    local file="$1"
    local search="$2"
    local replace="$3"

    # 转义 sed 特殊字符
    local escaped_search=$(printf '%s\n' "$search" | sed -e 's/[\/&]/\\&/g')
    local escaped_replace=$(printf '%s\n' "$replace" | sed -e 's/[\/&]/\\&/g')

    sed -i.bak "s|${escaped_search}|${escaped_replace}|g" "$file"
    rm -f "${file}.bak"
}

# 验证工作流名称（防止路径穿越和特殊字符注入）
validate_workflow_name() {
    local name="$1"

    if [ -z "$name" ]; then
        return 1
    fi

    # 检查长度
    if [ ${#name} -gt 100 ]; then
        print_error "工作流名称过长（最多 100 个字符）"
        return 1
    fi

    # 检查路径穿越
    if [[ "$name" == *".."* ]] || [[ "$name" == *"/"* ]]; then
        print_error "工作流名称不能包含 '..' 或 '/'"
        return 1
    fi

    return 0
}

# 创建唯一临时目录
create_temp_dir() {
    local temp_dir
    temp_dir=$(mktemp -d 2>/dev/null || mktemp -d -t 'stride')
    echo "$temp_dir"
}

# 清理函数（用于 trap）
cleanup_temp() {
    local temp_dir="$1"
    if [ -n "$temp_dir" ] && [ -d "$temp_dir" ]; then
        rm -rf "$temp_dir"
    fi
}
