#!/bin/bash

# Stride - AI 工作流系统 - 安装脚本配置助手
# 帮助你快速配置正确的仓库地址和分享链接

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

# 检测当前仓库信息
detect_repository() {
    print_info "检测仓库信息..."

    if ! git remote get-url origin &>/dev/null; then
        print_error "未找到 git origin，请先配置 git 仓库"
        return 1
    fi

    REPO_URL=$(git remote get-url origin)
    print_success "检测到仓库: $REPO_URL"

    # 提取用户名和仓库名
    if [[ $REPO_URL =~ github.com[:/]([^/]+)/([^/]+) ]]; then
        PLATFORM="github"
        USERNAME="${BASH_REMATCH[1]}"
        REPO_NAME="${BASH_REMATCH[2]}"
        BRANCH=$(git rev-parse --abbrev-ref HEAD)
        RAW_URL="https://github.com/$USERNAME/$REPO_NAME/raw/$BRANCH"
    elif [[ $REPO_URL =~ gitlab.com[:/]([^/]+)/([^/]+) ]]; then
        PLATFORM="gitlab"
        USERNAME="${BASH_REMATCH[1]}"
        REPO_NAME="${BASH_REMATCH[2]}"
        BRANCH=$(git rev-parse --abbrev-ref HEAD)
        RAW_URL="https://gitlab.com/$USERNAME/$REPO_NAME/-/raw/$BRANCH"
    elif [[ $REPO_URL =~ gitee.com[:/]([^/]+)/([^/]+) ]]; then
        PLATFORM="gitee"
        USERNAME="${BASH_REMATCH[1]}"
        REPO_NAME="${BASH_REMATCH[2]}"
        BRANCH=$(git rev-parse --abbrev-ref HEAD)
        RAW_URL="https://gitee.com/$USERNAME/$REPO_NAME/raw/$BRANCH"
    else
        print_warning "无法自动识别平台，请手动输入"
        return 1
    fi

    print_success "平台: $PLATFORM"
    print_success "用户/组织: $USERNAME"
    print_success "仓库: $REPO_NAME"
    print_success "分支: $BRANCH"
}

# 配置脚本
configure_scripts() {
    print_header "配置安装脚本"

    # 检查文件存在
    if [ ! -f "setup-workflow.sh" ]; then
        print_error "setup-workflow.sh 不存在"
        return 1
    fi

    print_info "更新 setup-workflow.sh..."
    sed -i.bak "s|https://github.com/your-org/ai-workflow-system.git|${REPO_URL}|g" setup-workflow.sh
    rm -f setup-workflow.sh.bak
    print_success "setup-workflow.sh 已更新"

    if [ -f "install.sh" ]; then
        print_info "更新 install.sh..."
        sed -i.bak "s|https://github.com/your-org/ai-workflow-system/raw/main|${RAW_URL}|g" install.sh
        rm -f install.sh.bak
        print_success "install.sh 已更新"
    fi

    if [ -f "ai-workflow.sh" ]; then
        print_info "更新 ai-workflow.sh..."
        sed -i.bak "s|https://github.com/your-org/ai-workflow-system|${REPO_URL//.git/}|g" ai-workflow.sh
        rm -f ai-workflow.sh.bak
        print_success "ai-workflow.sh 已更新"
    fi

    if [ -f "README-SHELL.md" ]; then
        print_info "更新 README-SHELL.md..."
        sed -i.bak "s|https://your-repo/ai-workflow-system.git|${REPO_URL}|g" README-SHELL.md
        rm -f README-SHELL.md.bak
        print_success "README-SHELL.md 已更新"
    fi
}

# 生成安装命令
generate_install_command() {
    print_header "安装命令"

    echo "复制此命令分享给团队："
    echo ""
    echo -e "${CYAN}curl -sSL ${RAW_URL}/install.sh | bash${NC}"
    echo ""
}

# 显示配置结果
show_configuration() {
    print_header "配置信息"

    echo "平台:        ${GREEN}$PLATFORM${NC}"
    echo "用户/组织:   ${GREEN}$USERNAME${NC}"
    echo "仓库名:      ${GREEN}$REPO_NAME${NC}"
    echo "分支:        ${GREEN}$BRANCH${NC}"
    echo "仓库 URL:    ${GREEN}$REPO_URL${NC}"
    echo "Raw 文件 URL: ${GREEN}$RAW_URL${NC}"
    echo ""
}

# 验证配置
verify_configuration() {
    print_header "验证配置"

    print_info "验证脚本已更新..."

    if grep -q "$REPO_URL" setup-workflow.sh 2>/dev/null; then
        print_success "setup-workflow.sh 已正确配置"
    else
        print_warning "setup-workflow.sh 可能未正确更新"
    fi

    if grep -q "$RAW_URL" install.sh 2>/dev/null; then
        print_success "install.sh 已正确配置"
    else
        print_warning "install.sh 可能未正确更新"
    fi

    echo ""
    print_info "下一步："
    echo "  1. 提交更改: git add . && git commit -m 'Configure install scripts'"
    echo "  2. 推送更改: git push origin $BRANCH"
    echo "  3. 分享命令给团队"
}

# 交互式菜单
interactive_menu() {
    local choice

    while true; do
        echo ""
        echo "选择操作:"
        echo "  1) 检测仓库并配置脚本"
        echo "  2) 手动输入仓库地址"
        echo "  3) 显示当前配置"
        echo "  4) 测试安装命令"
        echo "  5) 退出"
        echo ""
        read -p "请输入选项 [1-5]: " choice

        case $choice in
            1)
                if detect_repository; then
                    configure_scripts
                    show_configuration
                    generate_install_command
                    verify_configuration
                fi
                ;;
            2)
                read -p "请输入仓库 URL (git clone 地址): " REPO_URL
                read -p "请输入 Raw 文件 URL (不含 install.sh): " RAW_URL
                configure_scripts
                show_configuration
                generate_install_command
                ;;
            3)
                if [ -z "$REPO_URL" ]; then
                    if ! detect_repository; then
                        print_error "请先配置仓库"
                    fi
                fi
                show_configuration
                ;;
            4)
                if [ -z "$RAW_URL" ]; then
                    if ! detect_repository; then
                        print_error "无法获取仓库信息"
                        continue
                    fi
                fi
                generate_install_command
                echo "你可以测试此命令（在另一个目录）："
                echo "  mkdir -p /tmp/workflow-test && cd /tmp/workflow-test && git init"
                echo "  curl -sSL ${RAW_URL}/install.sh | bash"
                ;;
            5)
                echo "再见!"
                exit 0
                ;;
            *)
                print_error "无效的选项"
                ;;
        esac
    done
}

# 主函数
main() {
    print_header "🔧 Stride - AI 工作流系统 - 配置助手"

    if [ "$1" = "--auto" ] || [ "$1" = "-a" ]; then
        # 自动模式
        if detect_repository; then
            configure_scripts
            show_configuration
            generate_install_command
            verify_configuration
        else
            print_error "自动配置失败"
            exit 1
        fi
    else
        # 交互模式
        interactive_menu
    fi
}

main "$@"
