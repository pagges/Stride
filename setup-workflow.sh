#!/bin/bash

# Stride - AI 开发工作流系统 - 快速安装脚本
# 用法: bash setup-workflow.sh [--repo <repo-url>]

set -e

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

# 检查依赖
check_dependencies() {
    print_info "检查系统依赖..."

    if ! command -v git &> /dev/null; then
        print_error "未找到 git 命令"
        echo "请先安装 Git: https://git-scm.com/"
        exit 1
    fi

    if ! command -v bash &> /dev/null; then
        print_error "需要 Bash"
        exit 1
    fi

    print_success "依赖检查完毕"
}

# 检查网络连接
check_network() {
    print_info "检查网络连接..."

    if ! timeout 5 bash -c "echo > /dev/tcp/github.com/443" 2>/dev/null; then
        print_warning "无法连接到 GitHub，将尝试使用本地源"
        return 1
    fi

    print_success "网络连接正常"
    return 0
}

# 克隆或复制工作流系统
setup_workflow_system() {
    local repo_url="${1:-https://github.com/pagges/Stride.git}"
    local temp_dir=".stride_temp_$$"

    print_header "安装 Stride - AI 工作流系统"

    # 检查是否已存在
    if [ -d "ai-workflow-system" ]; then
        print_warning "ai-workflow-system 目录已存在"
        read -p "是否覆盖? [y/N] " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "跳过安装"
            return 0
        fi
        rm -rf ai-workflow-system
    fi

    print_info "从 $repo_url 克隆工作流系统..."

    # 使用临时目录克隆，避免嵌套问题
    if git clone "$repo_url" "$temp_dir"; then
        print_success "仓库已克隆"
    else
        print_error "克隆失败，请检查仓库地址"
        exit 1
    fi

    # 如果临时目录中有 ai-workflow-system 子目录，则提取该目录
    if [ -d "$temp_dir/ai-workflow-system" ]; then
        print_info "提取工作流系统..."
        mv "$temp_dir/ai-workflow-system" ai-workflow-system
    else
        # 否则直接使用克隆的内容作为工作流系统
        print_info "配置工作流系统..."
        mv "$temp_dir" ai-workflow-system
    fi

    # 清理临时目录（以防万一）
    rm -rf "$temp_dir"

    print_success "工作流系统已安装"

    # 添加执行权限
    chmod +x ai-workflow-system/ai-workflow.sh
    chmod +x ai-workflow-system/scripts/*.sh 2>/dev/null || true
}

# 初始化工作流系统
initialize_workflow() {
    local ai_tool="${1:-claude}"

    print_header "初始化工作流系统"

    if [ ! -f "ai-workflow-system/ai-workflow.sh" ]; then
        print_error "ai-workflow-system/ai-workflow.sh 不存在"
        exit 1
    fi

    print_info "运行初始化命令..."
    echo ""

    ./ai-workflow-system/ai-workflow.sh init "$ai_tool"
}

# 显示成功信息
show_success_message() {
    print_header "✨ 安装完成！"

    echo -e "${GREEN}Stride - AI 开发工作流系统已成功安装！${NC}"
    echo ""

    print_info "下一步操作："
    echo ""
    echo "  1. 创建第一个工作流："
    echo "     ${CYAN}./ai-workflow-system/ai-workflow.sh create <工作流名称>${NC}"
    echo ""
    echo "  例如："
    echo "     ${CYAN}./ai-workflow-system/ai-workflow.sh create 用户认证功能${NC}"
    echo ""
    echo "  2. 或在 AI 工具中使用："
    echo "     ${CYAN}/workflow${NC}"
    echo ""

    print_info "常用命令："
    echo "  ${CYAN}./ai-workflow-system/ai-workflow.sh create <name>${NC}   - 创建工作流"
    echo "  ${CYAN}./ai-workflow-system/ai-workflow.sh workflow${NC}        - 查看工作流"
    echo "  ${CYAN}./ai-workflow-system/ai-workflow.sh help${NC}            - 显示帮助"
    echo ""

    print_info "文档："
    echo "  README: ${CYAN}./ai-workflow-system/README-SHELL.md${NC}"
    echo ""
}

# 处理命令行参数
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --repo)
                REPO_URL="$2"
                shift 2
                ;;
            --ai)
                AI_TOOL="$2"
                shift 2
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                print_error "未知参数: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# 显示帮助信息
show_help() {
    cat << EOF
AI 开发工作流系统 - 快速安装脚本

用法:
  bash setup-workflow.sh [选项]

选项:
  --repo <url>      指定仓库地址（默认：GitHub）
  --help,-h         显示此帮助信息

示例:
  bash setup-workflow.sh
  bash setup-workflow.sh --repo https://github.com/pagges/Stride.git

更多信息: https://github.com/pagges/Stride
EOF
}

# 主函数
main() {
    local repo_url="https://github.com/pagges/Stride.git"
    local ai_tool="claude"  # 默认 AI 工具

    parse_arguments "$@"

    # 使用解析的值（如果有的话）
    repo_url="${REPO_URL:-$repo_url}"
    ai_tool="${AI_TOOL:-$ai_tool}"

    print_header "🚀 AI 工作流系统安装程序"

    check_dependencies
    echo ""

    if ! check_network; then
        print_warning "如果使用本地源，请手动配置"
    fi
    echo ""

    setup_workflow_system "${repo_url}"
    echo ""

    initialize_workflow "$ai_tool"
    echo ""

    show_success_message
}

# 运行主函数
main "$@"
