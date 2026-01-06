# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is **Stride** - an **AI Development Workflow System** (AI 开发工作流系统) - a shell-based toolkit that provides structured workflows for AI-assisted software development. The system helps track development tasks from requirements through design, implementation, testing, and bug fixing.

**Stride** stands for: **S**tructure **T**ask **R**eview **I**terate **D**eploy **E**xecute

## Key Commands

### Shell Script Commands

Main script: `ai-workflow-system/ai-workflow.sh`

```bash
./ai-workflow-system/ai-workflow.sh init           # Initialize (creates .claude/commands/)
./ai-workflow-system/ai-workflow.sh create <name>  # Create ai-workflow-<name>/ directory
./ai-workflow-system/ai-workflow.sh help           # Show help
```

### AI Tool Commands (after init)

| Command | Purpose |
|---------|---------|
| `/workflow` | Create/enter/view workflow status |
| `/dev <task-id>` | Execute task (e.g., `/dev TASK-001`) |
| `/doc-review [file]` | Review document completeness |
| `/code-review` | Review code quality |
| `/bug` | Submit bug to BugList.md |
| `/fix <bug-id>` | Fix bug (e.g., `/fix BUG-001`) |
| `/test` | Execute tests per TestCase.md |

## Architecture

### Core Files

- [ai-workflow.sh](ai-workflow-system/ai-workflow.sh) - Main entry point, command dispatcher
- [scripts/init.sh](ai-workflow-system/scripts/init.sh) - Initializes workflow system, creates `.claude/commands/` or `.qoder/commands/`
- [commands/](ai-workflow-system/commands/) - Full command specifications (AI reads these)
- [templates/](ai-workflow-system/templates/) - Document templates for new workflows

### Workflow Instance Structure

Each `ai-workflow-<name>/` directory contains:
- `Workflow.md` - State tracking with YAML frontmatter (stage, progress)
- `Requirements.md`, `Design.md`, `Task.md`, `BugList.md`, `TestCase.md`

### ID Formats

- **Tasks**: `TASK-001`, `TASK-002`, etc.
- **Bugs**: `BUG-001`, `BUG-002`, etc.

### Command Detection Pattern (Critical)

When executing `/workflow`:
1. Check if current directory starts with `ai-workflow-` → show status from Workflow.md
2. Otherwise, use `Glob: ai-workflow-*/Workflow.md` to find workflows
   - **ALWAYS use Glob tool** - never use Bash find/ls/grep for this

### Document Lifecycle

```
/workflow → Requirements.md → /doc-review → Design.md → /doc-review → Task.md
    ↓
/dev TASK-xxx → /code-review → (iterate or mark complete)
    ↓
/bug (if issues) → /fix BUG-xxx
    ↓
/test
```

## Important Notes

- **Workflow prefix**: All workflow directories MUST start with `ai-workflow-` (excluding `ai-workflow-system`)
- **Sudo warning**: Main script warns against sudo to prevent root-owned files
- **Bilingual**: Chinese UI messages in scripts, English in CLAUDE.md
- Commands in `.claude/commands/` are generated from [scripts/init.sh](ai-workflow-system/scripts/init.sh:99-206)
