#!/bin/bash

# Stride - AI 开发工作流系统 - 主启动脚本
# 版本: 0.2.1

set -eo pipefail

# 检查是否使用 sudo 运行（不推荐）
if [ "$EUID" -eq 0 ] || [ -n "$SUDO_USER" ]; then
    echo -e "\033[1;33m警告:\033[0m 检测到使用 sudo 运行此脚本"
    echo "这会导致创建的文件所有者为 root，普通用户无法删除"
    echo ""
    echo "建议直接运行（不使用 sudo）："
    echo "  $0 $*"
    echo ""
    # 在非交互模式下（STDIN 不是 TTY）自动取消
    if [ ! -t 0 ]; then
        echo "自动取消（非交互模式）"
        exit 1
    fi
    read -p "是否继续使用 sudo 运行? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "已取消"
        exit 1
    fi
fi

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 打印带颜色的消息
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

# 显示帮助信息
show_help() {
    cat << EOF
Stride - AI 开发工作流系统 v1.0.0

用法: ./stride.sh <命令> [参数]

命令:
  init              初始化工作流系统到当前项目
  create <名称>     创建新的工作流
  list              列出所有工作流
  status            显示当前工作流状态
  help              显示此帮助信息

示例:
  ./stride.sh init                  # 初始化系统
  ./stride.sh create user-auth      # 创建工作流
  ./stride.sh create 用户认证       # 中文名称也支持
  ./stride.sh list                  # 列出所有工作流
  ./stride.sh status                # 查看状态

工作流存储位置: .stride/stride-<名称>/

更多信息请访问: https://github.com/pagges/Stride
EOF
}

# 加载工具函数
source "$SCRIPT_DIR/scripts/utils.sh"

# 主命令分发
main() {
    local command="${1:-}"
    shift || true  # 移除第一个参数，以便传递剩余的参数

    case "$command" in
        init)
            source "$SCRIPT_DIR/scripts/init.sh"
            init_workflow "$@"
            ;;
        create)
            source "$SCRIPT_DIR/scripts/create.sh"
            create_workflow "$@"
            ;;
        list|ls)
            source "$SCRIPT_DIR/scripts/list.sh"
            list_workflows "$@"
            ;;
        status|st)
            source "$SCRIPT_DIR/scripts/status.sh"
            show_status "$@"
            ;;
        help|--help|-h)
            show_help
            ;;
        "")
            # 无参数时显示帮助
            show_help
            ;;
        *)
            print_error "未知命令: $command"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

main "$@"
