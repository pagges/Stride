# /dev - 开发任务

## 描述

执行开发任务，支持 Plan/Execute 两阶段工作流。第一阶段制定实现计划，第二阶段按计划执行实现。

## 使用方法

```
/dev TASK-001 --plan-only    # 制定任务实现计划（不修改代码）
/dev TASK-001 --execute      # 执行任务实现（按照计划修改代码）
/dev TASK-001                # 快速模式（跳过计划，直接执行）
/dev                         # 列出待开发任务供选择
```

## 功能

1. **Plan 阶段**（可选）：
   - 分析任务和微任务结构
   - 生成详细的实现计划
   - 列出需要修改的文件
   - 预估每个微任务的实现细节
   - **不直接修改代码**

2. **Execute 阶段**：
   - 根据计划逐步实现任务
   - 实现每个微任务
   - 自动生成 Git 提交
   - 运行测试验证
   - 自动触发 `/code-review`

3. **状态更新**：更新 Task.md 中的任务和微任务状态

## 执行规范

请阅读 `ai-workflow/INSTRUCTIONS.md` 中的 `/dev` 章节，严格按照规范执行。

### 前置检查（Context Engineering）

1. 检查是否在工作流目录内
2. 检查 Workflow.md 状态是否为 `implementation`
3. 检查 Requirements.md、Design.md、Task.md 是否存在
4. **收集完整上下文**：
   - 读取 Workflow.md 了解项目背景和目标
   - 读取 Requirements.md 了解需求
   - 读取 Design.md 了解设计方案
   - 读取 Task.md 了解任务定义
   - 扫描相关代码文件获取代码上下文

### Plan 阶段：制定实现计划

**命令**: `/dev TASK-001 --plan-only`

**输出**：生成结构化的实现计划，包含：

1. **任务分析**
   - 需求提取：从 Requirements.md 提取该任务的关键需求
   - 设计方案：从 Design.md 提取相关的设计决策
   - 微任务列表：确认 Task.md 中定义的微任务

2. **实现计划**
   ```
   微任务 TASK-001-1: 创建用户模型
   - 文件：src/models/user.ts, database/schema.sql
   - 实现步骤：
     1. 定义 User TypeScript 接口
     2. 创建数据库表
     3. 编写单元测试
   - 预计工时：1h

   微任务 TASK-001-2: 实现登录接口
   - 依赖：TASK-001-1 完成
   - 文件：src/api/auth.ts, src/services/auth.service.ts
   - 实现步骤：
     1. 创建 POST /api/auth/login 路由
     2. 实现密码验证逻辑
     3. 生成 JWT Token
     4. 编写集成测试
   - 预计工时：2h

   ... (更多微任务)
   ```

3. **文件清单**
   - 需要创建的文件
   - 需要修改的文件
   - 测试文件

4. **验证清单**
   - 每个微任务的验收标准
   - 测试用例
   - 预期输出

**用户审查**：
- 确认计划是否合理
- 提出修改建议
- 确认后再执行

### Execute 阶段：执行实现

**命令**: `/dev TASK-001 --execute`

**执行步骤**：

1. **读取审批的计划** - 从 Plan 阶段获取实现计划
2. **逐个实现微任务**：
   ```
   开始实现 TASK-001-1: 创建用户模型
   ├─ 创建 src/models/user.ts
   ├─ 创建 database/schema.sql
   ├─ 编写单元测试
   ├─ 运行测试验证
   ├─ Git 提交：feat(TASK-001): 创建用户模型
   └─ 标记 TASK-001-1 为完成

   开始实现 TASK-001-2: 实现登录接口 (依赖 TASK-001-1)
   ├─ 创建 src/api/auth.ts
   ├─ 实现 POST /api/auth/login
   ├─ 编写集成测试
   ├─ 运行测试验证
   ├─ Git 提交：feat(TASK-001): 实现登录接口
   └─ 标记 TASK-001-2 为完成

   ... (继续其他微任务)
   ```

3. **自动提交规范**：
   ```
   git commit -m "feat(TASK-001): 实现用户模型

   微任务: TASK-001-1
   描述: 定义 User 数据结构和数据库表

   修改文件:
   - src/models/user.ts (新增)
   - database/schema.sql (新增)

   验收标准:
   - ✓ User 模型包含所有必需字段
   - ✓ 数据库表已创建并支持唯一索引
   - ✓ 单元测试全部通过

   测试覆盖率: 95%"
   ```

4. **质量验证**：
   - 运行相关单元测试
   - 运行集成测试
   - 验证代码覆盖率
   - 检查代码规范

5. **自动代码审查**：
   - 完成所有微任务后，自动触发 `/code-review`
   - 根据审查结果询问用户：
     - 选项 a：继续完善代码
     - 选项 b：记录为 Bug（使用 `/bug`）
     - 选项 c：标记任务完成

### 快速模式：跳过 Plan 直接执行

**命令**: `/dev TASK-001` 或 `/dev TASK-001 --execute`

- 适用于简单任务或已熟悉的任务类型
- 跳过 Plan 阶段直接执行
- 仍然需要完整的上下文收集和验证

### 更新状态

1. **更新微任务状态**：
   - 修改 Task.md 中微任务的状态为 `completed`
   - 记录完成时间和提交哈希

2. **更新主任务状态**：
   ```
   TASK-001: 用户登录功能
   - 整体进度: 100% (3/3 微任务完成)
   - 状态: completed
   - 完成时间: 2024-01-06 14:30
   - 提交历史:
     • feat(TASK-001): 创建用户模型 (abc1234)
     • feat(TASK-001): 实现登录接口 (def5678)
     • feat(TASK-001): 添加登录限流 (ghi9012)
   ```

3. **更新 Workflow.md**：
   - 更新任务统计数据
   - 更新整体进度
   - 更新最后提交信息

## 示例输出

### Plan 阶段示例

```
/dev TASK-001 --plan-only

收集项目上下文...
✓ Workflow.md - 用户认证系统工作流
✓ Requirements.md - 用户认证功能需求
✓ Design.md - JWT Token 认证方案
✓ Task.md - 任务清单

======================================
实现计划：TASK-001 - 用户登录功能
======================================

【任务分析】
✓ 需求：实现用户登录接口，支持邮箱和用户名登录
✓ 设计：使用 JWT Token 认证，密码使用 bcrypt 加密
✓ 微任务数：3 个

【微任务分解】

TASK-001-1: 创建用户模型和数据库表 (1h)
├─ 文件: src/models/user.ts, database/schema.sql
├─ 步骤:
│  1. 定义 User TypeScript 接口 (id, email, username, password_hash)
│  2. 创建数据库表 (users)
│  3. 添加数据库索引 (email, username 唯一索引)
│  4. 编写单元测试
└─ 验收: User 模型测试通过

TASK-001-2: 实现登录接口 (2h)
├─ 文件: src/api/auth.ts, src/services/auth.service.ts
├─ 依赖: TASK-001-1 完成
├─ 步骤:
│  1. 创建 POST /api/auth/login 路由
│  2. 验证邮箱或用户名存在性
│  3. 密码 bcrypt 验证
│  4. 生成 JWT Token
│  5. 编写集成测试
└─ 验收: 登录接口集成测试通过

TASK-001-3: 添加登录限流和错误处理 (1h)
├─ 文件: src/middleware/rate-limit.ts, src/utils/error.ts
├─ 依赖: TASK-001-2 完成
├─ 步骤:
│  1. 实现登录错误次数计数
│  2. 5 次失败后锁定 15 分钟
│  3. 统一错误处理（不暴露内部细节）
│  4. 编写限流测试
└─ 验收: 限流和错误处理测试通过

【文件清单】
需要创建:
- src/models/user.ts
- src/api/auth.ts
- src/services/auth.service.ts
- src/middleware/rate-limit.ts
- database/schema.sql
- __tests__/user.test.ts
- __tests__/auth.integration.test.ts

需要修改:
- src/index.ts (导入路由)
- .env.example (JWT_SECRET)

【执行顺序】
1️⃣ TASK-001-1 → 2️⃣ TASK-001-2 → 3️⃣ TASK-001-3

总预计工时: 4 小时

======================================
请审查此计划是否合理，确认无误后再执行：
/dev TASK-001 --execute
======================================
```

### Execute 阶段示例

```
/dev TASK-001 --execute

读取实现计划...
✓ 计划已加载

======================================
开始执行：TASK-001 - 用户登录功能
======================================

【微任务 1/3】TASK-001-1: 创建用户模型和数据库表

✓ 创建文件: src/models/user.ts
✓ 创建文件: database/schema.sql
✓ 创建文件: __tests__/user.test.ts

运行单元测试...
✓ User 模型测试 [5/5 通过]
✓ 代码覆盖率: 98%

🔗 Git 提交: feat(TASK-001): 创建用户模型和数据库表 (abc1234)

✓ TASK-001-1 已完成 (9:15 - 10:20)

---

【微任务 2/3】TASK-001-2: 实现登录接口

✓ 创建文件: src/api/auth.ts
✓ 创建文件: src/services/auth.service.ts
✓ 修改文件: src/index.ts
✓ 创建文件: __tests__/auth.integration.test.ts

运行集成测试...
✓ 邮箱登录 [通过]
✓ 用户名登录 [通过]
✓ 错误密码 [通过]
✓ 用户不存在 [通过]
✓ JWT Token 验证 [通过]

✓ 集成测试 [5/5 通过]
✓ 代码覆盖率: 96%

🔗 Git 提交: feat(TASK-001): 实现登录接口 (def5678)

✓ TASK-001-2 已完成 (10:25 - 12:30)

---

【微任务 3/3】TASK-001-3: 添加登录限流和错误处理

✓ 创建文件: src/middleware/rate-limit.ts
✓ 修改文件: src/utils/error.ts
✓ 创建文件: __tests__/rate-limit.test.ts

运行单元测试...
✓ 限流逻辑 [5/5 通过]
✓ 错误处理 [3/3 通过]
✓ 代码覆盖率: 94%

🔗 Git 提交: feat(TASK-001): 添加登录限流和错误处理 (ghi9012)

✓ TASK-001-3 已完成 (13:00 - 14:00)

---

【所有微任务完成】✓ 3/3

执行代码审查...

/code-review 结果:
✓ 代码符合设计方案
✓ 实现了所有需求功能
✓ 测试覆盖率达到 96%
⚠ 建议：添加更详细的登录错误日志记录

请选择：
1. 继续完善代码 (采纳建议)
2. 记录为 Bug 后续处理
3. 标记任务完成 (接受为未来改进)

> 3

✓ TASK-001 已标记为完成
✓ Task.md 已更新
✓ Workflow.md 已更新

【工作流进度更新】
- 整体进度: 3/7 任务完成
- 代码提交: +3 新提交
- 代码覆盖率: 96%
```

## 相关文档

- `ai-workflow/INSTRUCTIONS.md` - 完整的执行规范
- `Requirements.md` - 需求文档
- `Design.md` - 设计文档
- `Task.md` - 任务清单

## 🎯 关键要点

### Context Engineering（上下文工程）

在执行开发前必须：
- 完整读取 Workflow.md、Requirements.md、Design.md、Task.md
- 扫描相关代码文件获取代码上下文
- 这使 AI 能在完整上下文中工作，减少错误

### Plan/Execute 分离

- **Plan 阶段**（`--plan-only`）：制定计划，**不修改代码**
  - 用户审查计划，提出反馈
  - 基于反馈调整计划
  - 确认无误后再执行

- **Execute 阶段**（`--execute`）：按计划实现，修改代码
  - 逐个实现微任务
  - 自动提交每个微任务
  - 自动运行测试

### 微任务分解

- 每个微任务应该是 1-2 小时的工作
- 支持微任务之间的依赖关系
- 每个微任务应该有清晰的验收标准
- 每个微任务完成后自动提交

### 自动提交规范

每个微任务提交应包含：
- 清晰的提交信息（`feat(TASK-XXX): 描述`）
- 修改文件列表
- 验收标准检查清单
- 测试覆盖率

### 代码审查时机

- **Plan 阶段的输出**应当被审查（计划本身）
- **实现完成后**触发 `/code-review`（代码质量）
- 不要在 Plan 阶段进行代码审查

## 注意事项

- 必须基于 Requirements.md 和 Design.md 进行开发
- 不得偏离设计随意实现
- 开发完成必须触发 `/code-review`
- 发现问题及时使用 `/bug` 记录
- 保持代码和文档同步
- 微任务的状态变更应该实时更新到 Task.md
