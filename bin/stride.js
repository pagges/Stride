#!/usr/bin/env node

/**
 * Stride CLI - AI-Assisted Development Workflow System
 *
 * Usage:
 *   npx stride-ai-workflow init [--ai claude|cursor|qoder]
 *   npx stride-ai-workflow create <workflow-name>
 *   npx stride-ai-workflow uninstall [--force]
 *   npx stride-ai-workflow --help
 *   npx stride-ai-workflow --version
 */

const { spawn } = require('child_process');
const path = require('path');
const fs = require('fs');
const readline = require('readline');

// 获取包的根目录
const PKG_ROOT = path.join(__dirname, '..');

// 颜色定义
const colors = {
  reset: '\x1b[0m',
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  cyan: '\x1b[36m'
};

// 打印函数
function printSuccess(msg) {
  console.log(`${colors.green}✓${colors.reset} ${msg}`);
}

function printError(msg) {
  console.log(`${colors.red}✗${colors.reset} ${msg}`);
}

function printWarning(msg) {
  console.log(`${colors.yellow}⚠${colors.reset} ${msg}`);
}

function printInfo(msg) {
  console.log(`${colors.blue}ℹ${colors.reset} ${msg}`);
}

function printHeader(msg) {
  console.log(`\n${colors.cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${colors.reset}`);
  console.log(`${colors.cyan}${msg}${colors.reset}`);
  console.log(`${colors.cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${colors.reset}\n`);
}

// 验证工作流名称（防止路径穿越和特殊字符注入）
function validateWorkflowName(name) {
  if (!name || typeof name !== 'string') {
    return { valid: false, error: '请指定工作流名称' };
  }

  // 检查长度
  if (name.length > 100) {
    return { valid: false, error: '工作流名称过长（最多 100 个字符）' };
  }

  // 检查路径穿越
  if (name.includes('..') || name.includes('/') || name.includes('\\')) {
    return { valid: false, error: '工作流名称不能包含 ".."、"/" 或 "\\"' };
  }

  // 检查危险的 shell 字符
  const dangerousChars = /[;&|`$(){}[\]<>!#*?'"]/;
  if (dangerousChars.test(name)) {
    return { valid: false, error: '工作流名称包含不允许的特殊字符' };
  }

  return { valid: true };
}

// 询问用户确认
function askConfirmation(question) {
  return new Promise((resolve) => {
    const rl = readline.createInterface({
      input: process.stdin,
      output: process.stdout
    });

    rl.question(question, (answer) => {
      rl.close();
      resolve(answer.toLowerCase() === 'y' || answer.toLowerCase() === 'yes');
    });
  });
}

// 递归删除目录
function removeDirectory(dirPath) {
  if (fs.existsSync(dirPath)) {
    fs.rmSync(dirPath, { recursive: true, force: true });
    return true;
  }
  return false;
}

// 显示帮助信息
function showHelp() {
  console.log(`
${colors.cyan}Stride${colors.reset} - AI-Assisted Development Workflow System

${colors.yellow}用法:${colors.reset}
  npx stride-ai-workflow init [选项]          初始化工作流系统
  npx stride-ai-workflow create <名称>        创建新工作流
  npx stride-ai-workflow uninstall [选项]     卸载工作流系统
  npx stride-ai-workflow --help               显示帮助信息
  npx stride-ai-workflow --version            显示版本信息

${colors.yellow}初始化选项:${colors.reset}
  --ai <tool>        指定 AI 工具 (claude|cursor|qoder|auto)
                     默认: auto (自动检测)

${colors.yellow}卸载选项:${colors.reset}
  --force            跳过确认提示，直接卸载
  --keep-workflows   保留已创建的工作流数据

${colors.yellow}示例:${colors.reset}
  npx stride-ai-workflow init                 # 自动检测 AI 工具
  npx stride-ai-workflow init --ai claude     # 指定使用 Claude
  npx stride-ai-workflow create user-auth     # 创建用户认证工作流
  npx stride-ai-workflow uninstall            # 卸载 Stride

${colors.yellow}更多信息:${colors.reset}
  文档: https://github.com/pagges/Stride
  问题: https://github.com/pagges/Stride/issues
`);
}

// 显示版本信息
function showVersion() {
  const packageJson = require(path.join(PKG_ROOT, 'package.json'));
  console.log(`Stride v${packageJson.version}`);
}

// 执行 shell 脚本
function runShellScript(scriptPath, args = []) {
  return new Promise((resolve, reject) => {
    // 确保脚本存在
    if (!fs.existsSync(scriptPath)) {
      printError(`脚本不存在: ${scriptPath}`);
      reject(new Error(`Script not found: ${scriptPath}`));
      return;
    }

    // 确保脚本有执行权限
    try {
      fs.chmodSync(scriptPath, 0o755);
    } catch (err) {
      printError(`无法设置执行权限: ${err.message}`);
      reject(new Error(`Cannot set executable permission: ${err.message}`));
      return;
    }

    const child = spawn('bash', [scriptPath, ...args], {
      cwd: process.cwd(),
      stdio: 'inherit',
      env: {
        ...process.env,
        STRIDE_PKG_ROOT: PKG_ROOT
      }
    });

    child.on('error', (err) => {
      printError(`执行失败: ${err.message}`);
      reject(err);
    });

    child.on('close', (code) => {
      if (code === 0) {
        resolve();
      } else {
        reject(new Error(`Script exited with code ${code}`));
      }
    });
  });
}

// 初始化命令
async function initCommand(options) {
  printHeader('Stride 工作流系统初始化');

  const setupScript = path.join(PKG_ROOT, 'setup-workflow.sh');
  const args = [];

  if (options.ai) {
    // 验证 AI 工具名称
    const validTools = ['claude', 'cursor', 'qoder', 'windsurf', 'trae', 'auto'];
    if (!validTools.includes(options.ai.toLowerCase())) {
      printError(`无效的 AI 工具: ${options.ai}`);
      printInfo(`有效选项: ${validTools.join(', ')}`);
      process.exit(1);
    }
    args.push('--ai', options.ai);
  }

  try {
    await runShellScript(setupScript, args);
    printSuccess('初始化完成！');
  } catch (err) {
    printError('初始化失败');
    process.exit(1);
  }
}

// 创建工作流命令
async function createCommand(workflowName) {
  // 验证工作流名称
  const validation = validateWorkflowName(workflowName);
  if (!validation.valid) {
    printError(validation.error);
    console.log('用法: npx stride-ai-workflow create <工作流名称>');
    process.exit(1);
  }

  printHeader(`创建工作流: ${workflowName}`);

  // 检查是否已初始化
  const strideTemplate = path.join(process.cwd(), '.stride', 'template');
  if (!fs.existsSync(strideTemplate)) {
    printError('工作流系统未初始化');
    printInfo('请先运行: npx stride-ai-workflow init');
    process.exit(1);
  }

  const strideScript = path.join(strideTemplate, 'stride.sh');

  try {
    await runShellScript(strideScript, ['create', workflowName]);
    printSuccess(`工作流 "${workflowName}" 创建成功！`);
  } catch (err) {
    printError('创建工作流失败');
    process.exit(1);
  }
}

// 卸载命令
async function uninstallCommand(options) {
  printHeader('Stride 工作流系统卸载');

  const cwd = process.cwd();
  const strideDir = path.join(cwd, '.stride');

  // 检查是否已安装
  if (!fs.existsSync(strideDir)) {
    printWarning('当前目录未安装 Stride 工作流系统');
    return;
  }

  // AI 工具命令目录列表
  const aiToolDirs = [
    { name: 'Claude Code', path: '.claude/commands' },
    { name: 'Cursor', path: '.cursor/commands' },
    { name: 'Qoder', path: '.qoder/commands' },
    { name: 'Windsurf', path: '.windsurf/commands' },
    { name: 'Trae', path: '.trae/commands' }
  ];

  // 查找已安装的 AI 工具命令
  const installedToolDirs = aiToolDirs.filter(tool =>
    fs.existsSync(path.join(cwd, tool.path))
  );

  // 查找已创建的工作流
  const workflows = [];
  if (fs.existsSync(strideDir)) {
    const entries = fs.readdirSync(strideDir, { withFileTypes: true });
    for (const entry of entries) {
      if (entry.isDirectory() && entry.name.startsWith('stride-')) {
        workflows.push(entry.name);
      }
    }
  }

  // 显示将要删除的内容
  console.log('将要删除以下内容：\n');

  printInfo('.stride/template/ (工作流系统模板)');

  if (!options['keep-workflows'] && workflows.length > 0) {
    for (const wf of workflows) {
      printWarning(`.stride/${wf}/ (工作流数据)`);
    }
  }

  for (const tool of installedToolDirs) {
    printInfo(`${tool.path}/ (${tool.name} 命令)`);
  }

  console.log('');

  // 确认删除
  if (!options.force) {
    const confirmed = await askConfirmation('确定要卸载 Stride 吗？此操作不可恢复 [y/N]: ');
    if (!confirmed) {
      printInfo('已取消卸载');
      return;
    }
  }

  console.log('');

  // 执行删除
  let hasError = false;

  // 删除 AI 工具命令目录
  for (const tool of installedToolDirs) {
    const toolPath = path.join(cwd, tool.path);
    try {
      if (removeDirectory(toolPath)) {
        printSuccess(`已删除 ${tool.path}/`);
      }
    } catch (err) {
      printError(`删除 ${tool.path}/ 失败: ${err.message}`);
      hasError = true;
    }
  }

  // 删除 .stride 目录
  if (options['keep-workflows'] && workflows.length > 0) {
    // 只删除 template 目录，保留工作流
    const templateDir = path.join(strideDir, 'template');
    try {
      if (removeDirectory(templateDir)) {
        printSuccess('已删除 .stride/template/');
      }
    } catch (err) {
      printError(`删除 .stride/template/ 失败: ${err.message}`);
      hasError = true;
    }
    printInfo(`已保留 ${workflows.length} 个工作流目录`);
  } else {
    // 删除整个 .stride 目录
    try {
      if (removeDirectory(strideDir)) {
        printSuccess('已删除 .stride/');
      }
    } catch (err) {
      printError(`删除 .stride/ 失败: ${err.message}`);
      hasError = true;
    }
  }

  console.log('');

  if (hasError) {
    printWarning('卸载完成，但部分文件删除失败');
  } else {
    printSuccess('Stride 工作流系统已成功卸载');
  }
}

// 解析命令行参数
function parseArgs(args) {
  const options = {};
  const positional = [];

  for (let i = 0; i < args.length; i++) {
    const arg = args[i];

    if (arg.startsWith('--')) {
      const key = arg.slice(2);
      const value = args[i + 1];

      if (value && !value.startsWith('--')) {
        options[key] = value;
        i++; // 跳过下一个参数
      } else {
        options[key] = true;
      }
    } else {
      positional.push(arg);
    }
  }

  return { options, positional };
}

// 主函数
async function main() {
  const args = process.argv.slice(2);

  // 没有参数时显示帮助
  if (args.length === 0) {
    showHelp();
    return;
  }

  const { options, positional } = parseArgs(args);
  const command = positional[0];

  // 处理全局选项
  if (options.help || command === 'help') {
    showHelp();
    return;
  }

  if (options.version || command === 'version') {
    showVersion();
    return;
  }

  // 处理命令
  switch (command) {
    case 'init':
      await initCommand(options);
      break;

    case 'create':
      await createCommand(positional[1]);
      break;

    case 'uninstall':
      await uninstallCommand(options);
      break;

    default:
      printError(`未知命令: ${command}`);
      console.log('运行 "npx stride-ai-workflow --help" 查看可用命令');
      process.exit(1);
  }
}

// 运行主函数
main().catch((err) => {
  const message = err?.message || String(err) || '未知错误';
  printError(`发生错误: ${message}`);
  if (process.env.DEBUG) {
    console.error(err);
  }
  process.exit(1);
});
