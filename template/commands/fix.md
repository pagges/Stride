# /fix - 修复问题

## 描述
修复指定的 Bug并更新状态。

## 使用方法
```
/fix BUG-001           # 修复指定 Bug
/fix                   # 列出待修复 Bug 供选择
```

## 功能
1. 读取 Bug 信息
2. 执行修复
3. 自动触发 `/code-review`
4. 更新 BugList.md 状态

## 相关文档
- `ai-workflow/INSTRUCTIONS.md` - 完整执行规范
- `BugList.md` - Bug 追踪文档
