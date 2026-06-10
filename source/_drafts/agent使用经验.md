---
title: agent使用经验
toc: true
comments: true
math: false
hide: true
excerpt: '本篇博客记录了我使用 AI Agent（主要是 Claude Code）进行日常开发的经验，包括工具链搭建、省钱技巧以及实际工作流分享。'
date: 2026-06-09 18:58:32
updated: 2026-06-09 18:58:32
categories: 开发经验
tags: [Agent, Claude Code, DeepSeek, ccswitch, AI编程]
---

## 前言

最近半年一直在使用 AI Agent 辅助开发，从一开始的 ChatGPT 复制粘贴，到现在形成了一套比较稳定的 Claude Code + ccswitch + 国内模型的工作流。本文记录一下我的使用经验和踩坑过程，希望对想入坑 Agent 开发的同学有所帮助。

## 工具介绍

### Claude Code

[Claude Code](https://docs.anthropic.com/en/docs/claude-code) 是 Anthropic 推出的命令行 AI 编程助手，可以直接在终端中与 Claude 交互，它能：

- 读写项目文件
- 执行终端命令
- 理解项目上下文
- 多步骤完成复杂开发任务

相比 Cursor 等 IDE 插件，Claude Code 的优势在于：
1. **上下文理解更强**：可以自主浏览项目结构、读取相关文件
2. **终端集成**：直接运行命令、查看输出、自动修复错误
3. **自主性高**：给一个任务描述，它能自己规划步骤并执行

### ccswitch

[ccswitch](https://github.com/yichuancc/ccswitch) 是一个 Claude Code 的模型切换工具，可以让你在 Claude Code 中使用不同的模型后端（比如 DeepSeek、Qwen 等国内模型）。

为什么需要 ccswitch？
- **省钱**：Claude Opus/Sonnet 的 API 价格不低，日常简单任务用国内模型可以大幅降低成本
- **灵活切换**：复杂任务用 Claude，简单任务用 DeepSeek，按需选择

### 国内模型

目前我主要使用的国内模型：
- **DeepSeek V3/R1**：综合能力强，代码生成质量不错，价格便宜
- **Qwen 系列**：阿里通义千问，中文理解好

## 环境搭建

### 1. 安装 Claude Code

```bash
# 使用 npm 全局安装
npm install -g @anthropic-ai/claude-code

# 启动
claude
```

### 2. 安装和配置 ccswitch

```bash
# 安装 ccswitch
npm install -g ccswitch

# 配置国内模型的 API
ccswitch config
```

配置时需要填入你的 API Key 和 endpoint：
- DeepSeek API：`https://api.deepseek.com`
- 其他兼容 OpenAI 格式的模型也可以接入

### 3. 切换模型

```bash
# 查看可用模型
ccswitch list

# 切换到 DeepSeek
ccswitch use deepseek

# 切换回 Claude
ccswitch use claude
```

## 我的工作流

### 整体思路：分层使用

我的核心原则是**根据任务复杂度选择模型**，避免用大炮打蚊子：

| 任务类型 | 使用模型 | 原因 |
|---------|---------|------|
| 架构设计、复杂重构 | Claude Opus/Sonnet | 推理能力强，理解深 |
| 日常编码、简单功能 | DeepSeek V3 | 便宜，速度快，质量够用 |
| 代码解释、文档生成 | DeepSeek V3 | 不需要太强的推理 |
| Bug 修复、调试 | Claude Sonnet | 需要准确理解上下文 |

### 工作流一：Coding Plan 模式

对于较复杂的功能开发，我通常采用 **Plan → Execute** 的两阶段模式：

**第一阶段：制定计划（使用 Claude）**

```
> 请帮我规划一下如何实现 XXX 功能，列出步骤和涉及的文件，不要直接写代码
```

Claude 会分析项目结构，给出详细的实施计划。

**第二阶段：执行计划（使用 DeepSeek 或 Claude）**

拿到计划后，逐步执行每个步骤。简单的步骤可以切换到 DeepSeek 来节省成本：

```bash
# 切换到便宜的模型执行简单任务
ccswitch use deepseek

# 执行计划中的具体步骤
> 按照以下计划的第1步，创建 xxx 文件...
```

遇到复杂步骤再切回 Claude：

```bash
ccswitch use claude
```

### 工作流二：日常开发

对于日常的小任务，直接用 DeepSeek 就够了：

```bash
ccswitch use deepseek

# 简单任务示例
> 帮我给这个函数加个参数校验
> 帮我写个单元测试
> 把这个组件的样式改成 flex 布局
```

### 工作流三：Debug 模式

遇到难搞的 bug，切换到 Claude 让它自主排查：

```bash
ccswitch use claude

> 运行 npm test 报错了，请帮我排查原因并修复
```

Claude Code 会自己运行命令、查看报错、定位问题、尝试修复，整个过程基本不需要人工干预。

## 使用技巧

### 1. 善用 CLAUDE.md

在项目根目录创建 `CLAUDE.md` 文件，写入项目的背景信息和开发规范。Claude Code 每次启动都会读取它，相当于给 Agent 设置了持久记忆：

```markdown
# 项目说明
这是一个基于 React + TypeScript 的前端项目...

# 开发规范
- 使用 pnpm 作为包管理器
- 组件使用函数式组件 + Hooks
- 样式使用 TailwindCSS
```

### 2. 任务拆分

不要一次给太大的任务。把大需求拆成小步骤，每步确认无误再继续：

```
❌ 帮我实现一个完整的用户认证系统
✅ 先帮我创建 User 模型和数据库迁移
✅ 然后实现注册接口
✅ 再实现登录接口和 JWT 生成
```

### 3. 及时纠正

如果 Agent 走偏了方向，立刻打断并纠正，不要等它做完再推倒重来：

```
> 停，不要用 class 组件，我们项目统一用函数式组件，请重新来
```

### 4. 利用 /compact 节省上下文

对话太长时，使用 `/compact` 命令压缩上下文，避免 token 浪费：

```
/compact
```

### 5. 复杂任务使用 Plan 模式

Claude Code 内置了 plan 模式（shift+tab切换），让它先制定计划再执行：

```
> /plan 帮我重构这个模块的错误处理逻辑
```

## 成本控制

### Token 消耗参考

| 模型 | 输入价格 | 输出价格 | 适用场景 |
|------|---------|---------|---------|
| Claude Opus | $15/M tokens | $75/M tokens | 复杂架构设计 |
| Claude Sonnet | $3/M tokens | $15/M tokens | 日常开发主力 |
| DeepSeek V3 | ¥1/M tokens | ¥2/M tokens | 简单任务 |

### 省钱策略

1. **简单任务一律用国内模型**：生成模板代码、写注释、格式化等
2. **善用缓存**：Claude Code 有 prompt cache，5 分钟内复用上下文不重复收费
3. **控制上下文长度**：定期 `/compact`，避免把无关文件带入上下文
4. **Plan 模式省钱**：先让模型制定计划（消耗少），确认后再执行（避免错误执行浪费 token）

## 常见问题


### Q: 国内模型能完全替代 Claude 吗？

目前还不能。DeepSeek 在以下场景表现明显不如 Claude：
- 复杂的多文件重构
- 需要深度理解项目架构的任务
- 长上下文推理
- 细致的 Bug 排查

但对于 70% 的日常编码任务，DeepSeek 已经够用了。


## 总结

AI Agent 开发的核心是**找到适合自己的工作流**，而不是盲目追求最强的模型。我的经验是：

1. **分层使用**：复杂任务用强模型，简单任务用便宜模型
2. **Plan 先行**：先想清楚再动手，减少返工
3. **善用工具链**：Claude Code + ccswitch 的组合兼顾了能力和成本
4. **持续迭代**：随着模型能力提升和新工具出现，工作流也要不断调整

希望这篇文章对你有帮助！如果有问题欢迎评论交流。
