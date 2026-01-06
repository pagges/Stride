#!/bin/bash

# Stride - AI 开发工作流系统 - 主启动脚本
# 版本: 1.0.0

set -e

# 检查是否使用 sudo 运行（不推荐）
if [ "$EUID" -eq 0 ] || [ -n "$SUDO_USER" ]; then
    echo -e "\033[1;33m警告:\033[0m 检测到使用 sudo 运行此脚本"
    echo "这会导致创建的文件所有者为 root，普通用户无法删除"
    echo ""
    echo "建议直接运行（不使用 sudo）："
    echo "  $0 $*"
    echo ""
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

用法: ./ai-workflow.sh <command> [options]

命令:
  init                初始化工作流系统到当前项目
  create <name>       创建新的工作流
  workflow            工作流管理（创建/进入/查看状态）
  dev <task-id>       开发指定任务
  doc-review [file]   审查文档
  code-review         代码审查
  bug <title>         提交 Bug
  fix <bug-id>        修复 Bug
  test                执行测试
  help                显示此帮助信息

示例:
  ./ai-workflow.sh init                    # 初始化到项目
  ./ai-workflow.sh create user-auth        # 创建工作流
  ./ai-workflow.sh workflow                # 查看工作流状态
  ./ai-workflow.sh dev TASK-001            # 开发任务
  ./ai-workflow.sh bug "密码未加密"         # 提交 Bug

更多信息请访问: https://github.com/your-repo/stride
EOF
}

# 加载工具函数
source "$SCRIPT_DIR/scripts/utils.sh"

# 主命令分发
main() {
    if [ $# -eq 0 ]; then
        show_help
        exit 0
    fi

    local command="$1"
    shift

    case "$command" in
        init)
            source "$SCRIPT_DIR/scripts/init.sh"
            init_workflow "$@"
            ;;
        create)
            source "$SCRIPT_DIR/scripts/create-workflow.sh"
            create_workflow "$@"
            ;;
        workflow)
            source "$SCRIPT_DIR/scripts/workflow.sh"
            workflow_command "$@"
            ;;
        dev)
            source "$SCRIPT_DIR/scripts/dev.sh"
            dev_command "$@"
            ;;
        doc-review)
            source "$SCRIPT_DIR/scripts/doc-review.sh"
            doc_review_command "$@"
            ;;
        code-review)
            source "$SCRIPT_DIR/scripts/code-review.sh"
            code_review_command "$@"
            ;;
        bug)
            source "$SCRIPT_DIR/scripts/bug.sh"
            bug_command "$@"
            ;;
        fix)
            source "$SCRIPT_DIR/scripts/fix.sh"
            fix_command "$@"
            ;;
        test)
            source "$SCRIPT_DIR/scripts/test.sh"
            test_command "$@"
            ;;
        help|--help|-h)
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
