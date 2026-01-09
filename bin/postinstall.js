#!/usr/bin/env node

/**
 * Post-install script for Stride
 * Shows welcome message after installation
 */

const colors = {
    reset: '\x1b[0m',
    green: '\x1b[32m',
    cyan: '\x1b[36m',
    yellow: '\x1b[33m'
};

console.log(`
${colors.cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${colors.reset}
${colors.green}✓ Stride 安装成功！${colors.reset}
${colors.cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${colors.reset}

${colors.yellow}快速开始:${colors.reset}

  在你的项目目录运行:
  ${colors.cyan}npx stride init${colors.reset}

  或者查看帮助:
  ${colors.cyan}npx stride --help${colors.reset}

${colors.yellow}更多信息:${colors.reset}
  文档: https://github.com/pagges/Stride
  
`);
