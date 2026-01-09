#!/usr/bin/env node

/**
 * Stride CLI - AI-Assisted Development Workflow System
 * 
 * Usage:
 *   npx @pagges/stride init [--ai claude|cursor|qoder]
 *   npx @pagges/stride create <workflow-name>
 *   npx @pagges/stride --help
 *   npx @pagges/stride --version
 */

const { spawn } = require('child_process');
const path = require('path');
const fs = require('fs');

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

function printInfo(msg) {
  console.log(`${colors.blue}ℹ${colors.reset} ${msg}`);
}

function printHeader(msg) {
  console.log(`\n${colors.cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${colors.reset}`);
  console.log(`${colors.cyan}${msg}${colors.reset}`);
  console.log(`${colors.cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${colors.reset}\n`);
}

// 显示帮助信息
function showHelp() {
  console.log(`
${colors.cyan}Stride${colors.reset} - AI-Assisted Development Workflow System

${colors.yellow}用法:${colors.reset}
  npx @pagges/stride init [选项]          初始化工作流系统
  npx @pagges/stride create <名称>        创建新工作流
  npx @pagges/stride --help               显示帮助信息
  npx @pagges/stride --version            显示版本信息

${colors.yellow}初始化选项:${colors.reset}
  --ai <tool>        指定 AI 工具 (claude|cursor|qoder|auto)
                     默认: auto (自动检测)

${colors.yellow}示例:${colors.reset}
  npx @pagges/stride init                 # 自动检测 AI 工具
  npx @pagges/stride init --ai claude     # 指定使用 Claude
  npx @pagges/stride create user-auth     # 创建用户认证工作流

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
      fs.chmodSync(scriptPath, '755');
    } catch (err) {
      printError(`无法设置执行权限: ${err.message}`);
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
  if (!workflowName) {
    printError('请指定工作流名称');
    console.log('用法: npx @pagges/stride create <工作流名称>');
    process.exit(1);
  }

  printHeader(`创建工作流: ${workflowName}`);
  
  // 检查是否已初始化
  const strideTemplate = path.join(process.cwd(), '.stride', 'template');
  if (!fs.existsSync(strideTemplate)) {
    printError('工作流系统未初始化');
    printInfo('请先运行: npx @pagges/stride init');
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
      
    default:
      printError(`未知命令: ${command}`);
      console.log('运行 "npx @pagges/stride --help" 查看可用命令');
      process.exit(1);
  }
}

// 运行主函数
main().catch((err) => {
  printError(`发生错误: ${err.message}`);
  process.exit(1);
});
