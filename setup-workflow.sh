#!/bin/bash

# Stride - AI 开发工作流系统 - 快速安装脚本
# 用法: bash setup-workflow.sh [--ai <tool>]

set -eo pipefail

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 加载共享函数库
if [ -f "$SCRIPT_DIR/lib/common.sh" ]; then
    source "$SCRIPT_DIR/lib/common.sh"
else
    # 内联定义（用于 npx 安装场景）
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
    print_header() {
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${CYAN}$1${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
    }
fi

# 临时目录清理
TEMP_DIR=""
cleanup() {
    if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
    fi
}
trap cleanup EXIT

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

    print_header "安装 Stride - AI 工作流系统"

    # 检查是否已存在
    if [ -d ".stride/template" ]; then
        print_warning ".stride/template 目录已存在"
        read -p "是否覆盖? [y/N] " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "跳过安装"
            return 0
        fi
        # 安全删除：验证路径
        if [ -d ".stride" ] && [ -d ".stride/template" ]; then
            rm -rf .stride/template
        fi
    fi

    print_info "从 $repo_url 克隆工作流系统..."

    # 使用唯一临时目录
    TEMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'stride')

    if git clone "$repo_url" "$TEMP_DIR"; then
        print_success "仓库已克隆"
    else
        print_error "克隆失败，请检查仓库地址"
        exit 1
    fi

    # 检测并提取工作流系统
    mkdir -p .stride

    if [ -d "$TEMP_DIR/.stride/template" ]; then
        # 本地打包的结构
        print_info "提取工作流系统（本地打包结构）..."
        mv "$TEMP_DIR/.stride/template" .stride/template
    elif [ -d "$TEMP_DIR/ai-workflow-system" ]; then
        # GitHub 仓库结构
        print_info "提取工作流系统（GitHub 仓库结构）..."
        mv "$TEMP_DIR/ai-workflow-system" .stride/template
    else
        # 整个仓库作为模板
        print_info "配置工作流系统（使用整个仓库）..."
        mv "$TEMP_DIR" .stride/template
        TEMP_DIR=""  # 已移动，不需要清理
    fi

    print_success "工作流系统已安装"

    # 添加执行权限
    if [ -f ".stride/template/stride.sh" ]; then
        chmod +x .stride/template/stride.sh
        chmod +x .stride/template/scripts/*.sh 2>/dev/null || true
    elif [ -f ".stride/template/ai-workflow.sh" ]; then
        chmod +x .stride/template/ai-workflow.sh
        chmod +x .stride/template/scripts/*.sh 2>/dev/null || true
    fi
}

# 初始化工作流系统
initialize_workflow() {
    local ai_tool="${1:-auto}"

    print_header "初始化工作流系统"

    # 检测脚本位置
    local workflow_script=""
    if [ -f ".stride/template/stride.sh" ]; then
        workflow_script="./.stride/template/stride.sh"
    elif [ -f ".stride/template/ai-workflow.sh" ]; then
        workflow_script="./.stride/template/ai-workflow.sh"
    else
        print_error "工作流脚本不存在"
        print_info "请检查 .stride/template/ 目录"
        exit 1
    fi

    print_info "运行初始化命令..."
    echo ""

    "$workflow_script" init "$ai_tool"
}

# 显示成功信息
show_success_message() {
    print_header "安装完成！"

    echo -e "${GREEN}Stride - AI 开发工作流系统已成功安装！${NC}"
    echo ""

    print_info "现在你可以："
    echo ""
    echo "  在 AI Coding 工具中使用"
    echo -e "     ${CYAN}/workflow${NC}              # 创建或管理工作流"
    echo ""
    echo "  或使用 Shell 命令"
    echo -e "     ${CYAN}./.stride/template/stride.sh create <名称>${NC}"
    echo ""

    print_info "可用指令："
    echo -e "  ${CYAN}/workflow${NC}              - 创建或进入工作流"
    echo -e "  ${CYAN}/dev TASK-001${NC}          - 开发任务"
    echo -e "  ${CYAN}/doc-review${NC}            - 文档审查"
    echo -e "  ${CYAN}/code-review${NC}           - 代码审查"
    echo -e "  ${CYAN}/bug${NC}                   - 提交问题"
    echo -e "  ${CYAN}/fix BUG-001${NC}           - 修复问题"
    echo -e "  ${CYAN}/test${NC}                  - 执行测试"
    echo ""

    print_info "工作流存储位置: .stride/stride-<名称>/"
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
Stride - AI 开发工作流系统 - 快速安装脚本

用法:
  bash setup-workflow.sh [选项]

选项:
  --ai <tool>     指定 AI 工具 (claude|cursor|qoder|auto)
  --help,-h       显示此帮助信息

示例:
  bash setup-workflow.sh
  bash setup-workflow.sh --ai claude

更多信息: https://github.com/pagges/Stride
EOF
}

# 主函数
main() {
    local repo_url="https://github.com/pagges/Stride.git"
    local ai_tool="auto"

    parse_arguments "$@"

    # 使用解析的值（如果有的话）
    repo_url="${REPO_URL:-$repo_url}"
    ai_tool="${AI_TOOL:-$ai_tool}"

    print_header "Stride 工作流系统安装程序"

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
