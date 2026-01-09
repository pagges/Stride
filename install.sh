#!/bin/bash

# Stride - AI 开发工作流系统 - 远程安装脚本
# 用于通过 curl 或 wget 远程执行
#
# 使用方式:
# curl -sSL https://github.com/pagges/Stride/raw/main/install.sh | bash
# 或
# wget -qO- https://github.com/pagges/Stride/raw/main/install.sh | bash

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_info() { echo -e "${BLUE}ℹ${NC} $1"; }
print_header() { echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n${CYAN}$1${NC}\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"; }

# 检查依赖
check_dependencies() {
    print_info "检查系统依赖..."

    if ! command -v git &> /dev/null; then
        print_error "未找到 git 命令"
        echo "请先安装 Git: https://git-scm.com/"
        exit 1
    fi

    if ! command -v curl &> /dev/null && ! command -v wget &> /dev/null; then
        print_error "需要 curl 或 wget"
        exit 1
    fi

    print_success "依赖检查完毕"
}

# 下载文件的通用函数
download_file() {
    local url="$1"
    local output="$2"

    if command -v curl &> /dev/null; then
        curl -sSL "$url" -o "$output" || return 1
    elif command -v wget &> /dev/null; then
        wget -q "$url" -O "$output" || return 1
    else
        return 1
    fi
}

# 下载并执行本地设置脚本
download_setup_script() {
    local base_url="${1:-https://github.com/pagges/Stride/raw/main}"
    local ai_tool="${2:-claude}"
    local setup_url="${base_url}/setup-workflow.sh"

    print_info "从 $setup_url 下载设置脚本..."

    if download_file "$setup_url" "/tmp/setup-workflow.sh"; then
        print_success "设置脚本已下载"
        chmod +x /tmp/setup-workflow.sh
        /tmp/setup-workflow.sh --repo "${base_url/\/raw\/main/}.git" --ai "$ai_tool"
        rm -f /tmp/setup-workflow.sh
    else
        print_error "下载失败，请检查网络连接"
        exit 1
    fi
}

# 主函数
main() {
    local base_url="${1:-https://github.com/pagges/Stride/raw/main}"

    print_header "Stride - AI 工作流系统远程安装"

    # 确保在项目目录
    if [ ! -d ".git" ] && [ ! -f "package.json" ] && [ ! -f "README.md" ]; then
        print_warning "未检测到项目根目录,请使用 git init 初始化项目之后再运行"
        read -p "是否继续在当前目录安装? [y/N] " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "已取消"
            exit 0
        fi
    fi

    check_dependencies
    echo ""

    download_setup_script "$base_url" "auto"
}

main "$@"
