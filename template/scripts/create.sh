#!/bin/bash

# Stride - 创建新工作流

# 获取脚本目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$SCRIPT_DIR/../templates"

# 颜色定义（确保可用）
CYAN='\033[0;36m'
NC='\033[0m'

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

# 创建工作流
create_workflow() {
    local workflow_name="$1"
    local current_date=$(date +%Y-%m-%d)

    # 验证工作流名称
    if [ -z "$workflow_name" ]; then
        print_error "请提供工作流名称"
        echo ""
        echo "用法: ./stride.sh create <工作流名称>"
        echo ""
        echo "示例:"
        echo "  ./stride.sh create user-auth"
        echo "  ./stride.sh create 用户认证"
        exit 1
    fi

    # 验证名称安全性
    if ! validate_workflow_name "$workflow_name"; then
        exit 1
    fi

    # 清理名称（移除空格，转换为小写友好格式）
    local safe_name=$(echo "$workflow_name" | tr ' ' '-')
    local stride_dir=".stride"
    local workflow_dir="${stride_dir}/stride-${safe_name}"

    # 确保 .stride 目录存在
    if [ ! -d "$stride_dir" ]; then
        mkdir -p "$stride_dir"
        print_success "创建 .stride/ 目录"
    fi

    # 检查工作流是否已存在
    if [ -d "$workflow_dir" ]; then
        print_error "工作流 'stride-${safe_name}' 已存在"
        echo ""
        print_info "可用选项:"
        echo "  1. 使用不同的名称创建新工作流"
        echo "  2. 删除现有目录后重新创建: rm -rf $workflow_dir"
        echo "  3. 使用 './.stride/template/stride.sh list' 查看现有工作流"
        exit 1
    fi

    print_info "正在创建工作流: $workflow_name"
    echo ""

    # 创建工作流目录
    mkdir -p "$workflow_dir"
    print_success "创建目录: $workflow_dir/"

    # 复制并处理模板
    create_workflow_documents "$workflow_dir" "$workflow_name" "$current_date"

    echo ""
    print_success "工作流创建完成！"
    echo ""

    # 显示下一步指引
    show_next_steps "$workflow_dir" "$workflow_name"
}

# 创建工作流文档
create_workflow_documents() {
    local workflow_dir="$1"
    local workflow_name="$2"
    local current_date="$3"

    # Workflow.md
    if [ -f "$TEMPLATES_DIR/Workflow.md.template" ]; then
        sed -e "s/{{工作流名称}}/$workflow_name/g" \
            -e "s/{{工作流描述}}/待填写/g" \
            -e "s/2024-01-06/$current_date/g" \
            -e "s/name: 工作流名称/name: $workflow_name/g" \
            "$TEMPLATES_DIR/Workflow.md.template" > "$workflow_dir/Workflow.md"
    else
        create_default_workflow_md "$workflow_dir" "$workflow_name" "$current_date"
    fi
    print_success "创建 Workflow.md"

    # Requirements.md
    if [ -f "$TEMPLATES_DIR/Requirements.md.template" ]; then
        cp "$TEMPLATES_DIR/Requirements.md.template" "$workflow_dir/Requirements.md"
    else
        create_default_requirements_md "$workflow_dir" "$workflow_name"
    fi
    print_success "创建 Requirements.md"

    # Design.md
    if [ -f "$TEMPLATES_DIR/Design.md.template" ]; then
        cp "$TEMPLATES_DIR/Design.md.template" "$workflow_dir/Design.md"
    else
        create_default_design_md "$workflow_dir" "$workflow_name"
    fi
    print_success "创建 Design.md"

    # Task.md
    if [ -f "$TEMPLATES_DIR/Task.md.template" ]; then
        cp "$TEMPLATES_DIR/Task.md.template" "$workflow_dir/Task.md"
    else
        create_default_task_md "$workflow_dir" "$workflow_name"
    fi
    print_success "创建 Task.md"

    # BugList.md
    if [ -f "$TEMPLATES_DIR/BugList.md.template" ]; then
        cp "$TEMPLATES_DIR/BugList.md.template" "$workflow_dir/BugList.md"
    else
        create_default_buglist_md "$workflow_dir"
    fi
    print_success "创建 BugList.md"

    # TestCase.md
    if [ -f "$TEMPLATES_DIR/TestCase.md.template" ]; then
        cp "$TEMPLATES_DIR/TestCase.md.template" "$workflow_dir/TestCase.md"
    else
        create_default_testcase_md "$workflow_dir"
    fi
    print_success "创建 TestCase.md"
}

# 显示下一步操作
show_next_steps() {
    local workflow_dir="$1"
    local workflow_name="$2"

    echo "======================================"
    echo "工作流: $workflow_name"
    echo "======================================"
    echo ""
    print_info "当前阶段: requirements (需求分析)"
    echo ""
    print_info "下一步操作:"
    echo ""
    echo -e "  1. 编写需求文档:"
    echo -e "     编辑 ${CYAN}${workflow_dir}/Requirements.md${NC}"
    echo ""
    echo -e "  2. 审查需求文档:"
    echo -e "     ${CYAN}/doc-review${NC}"
    echo ""
    echo -e "  3. 查看工作流状态:"
    echo -e "     ${CYAN}/workflow${NC} 或 ${CYAN}./.stride/template/stride.sh status${NC}"
    echo ""
}

# 默认模板创建函数（当模板文件不存在时使用）
create_default_workflow_md() {
    local dir="$1"
    local name="$2"
    local date="$3"

    cat > "$dir/Workflow.md" << EOF
---
name: $name
description: 待填写
version: 1.0
created_at: $date
updated_at: $date
status: requirements
stages:
  requirements: { status: in_progress }
  design: { status: not_started }
  implementation: { status: not_started }
  testing: { status: not_started }
  deployment: { status: not_started }
---

# 工作流：$name

## 概述

**描述**: 待填写

## 当前进度

| 阶段 | 状态 |
|------|------|
| 需求分析 | 进行中 |
| 系统设计 | 未开始 |
| 代码实现 | 未开始 |
| 测试验收 | 未开始 |
| 上线部署 | 未开始 |

## 下一步

1. 编写 Requirements.md
2. 执行 /doc-review 审查需求
EOF
}

create_default_requirements_md() {
    local dir="$1"
    local name="$2"

    cat > "$dir/Requirements.md" << 'EOF'
# 需求文档

## 1. 项目背景

（描述项目的背景和目的）

## 2. 功能需求

### 2.1 核心功能

- [ ] 功能1：描述
- [ ] 功能2：描述

### 2.2 辅助功能

- [ ] 功能1：描述

## 3. 非功能需求

- 性能要求：
- 安全要求：
- 可用性要求：

## 4. 约束条件

- 技术约束：
- 时间约束：
- 资源约束：

## 5. 验收标准

- [ ] 标准1
- [ ] 标准2
EOF
}

create_default_design_md() {
    local dir="$1"
    local name="$2"

    cat > "$dir/Design.md" << 'EOF'
# 设计文档

## 1. 系统架构

（描述整体架构设计）

## 2. 模块设计

### 2.1 模块A

- 职责：
- 接口：

## 3. 数据设计

### 3.1 数据模型

（描述数据结构）

## 4. 接口设计

### 4.1 API 设计

（描述 API 接口）

## 5. 技术选型

| 类别 | 技术 | 理由 |
|------|------|------|
| 语言 | | |
| 框架 | | |
EOF
}

create_default_task_md() {
    local dir="$1"
    local name="$2"

    cat > "$dir/Task.md" << 'EOF'
# 任务清单

## 任务概览

| 任务ID | 任务名称 | 状态 | 优先级 |
|--------|----------|------|--------|
| TASK-001 | 任务名称 | pending | P1 |

---

## TASK-001: 任务名称

**状态**: pending
**优先级**: P1
**预估**: 2h

### 描述

（任务描述）

### 微任务分解

- [ ] TASK-001-1: 子任务1
- [ ] TASK-001-2: 子任务2

### 验收标准

- [ ] 标准1
- [ ] 标准2

### 相关文件

- `path/to/file`
EOF
}

create_default_buglist_md() {
    local dir="$1"

    cat > "$dir/BugList.md" << 'EOF'
# Bug 列表

## 概览

| Bug ID | 描述 | 状态 | 优先级 |
|--------|------|------|--------|
| - | 暂无 Bug | - | - |

---

## Bug 详情

（暂无 Bug）
EOF
}

create_default_testcase_md() {
    local dir="$1"

    cat > "$dir/TestCase.md" << 'EOF'
# 测试用例

## 概览

| 用例ID | 描述 | 状态 |
|--------|------|------|
| TC-001 | 测试用例1 | pending |

---

## TC-001: 测试用例1

**状态**: pending
**类型**: 单元测试

### 前置条件

（描述测试前置条件）

### 测试步骤

1. 步骤1
2. 步骤2

### 预期结果

（描述预期结果）

### 实际结果

（待执行）
EOF
}
