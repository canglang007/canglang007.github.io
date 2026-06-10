# 🌊 canglang007 的个人博客

> 非淡泊无以明志，非宁静无以致远

个人博客，基于 [Hexo](https://hexo.io/) 和 [Fluid](https://github.com/fluid-dev/hexo-theme-fluid) 主题构建。记录技术学习、项目经验和生活思考。

🔗 **在线访问**：[https://canglang007.github.io](https://canglang007.github.io)

## ✨ 功能特性

- 🎨 Fluid 主题，响应式设计
- 💬 Gitalk 评论系统
- 🏷️ 文章分类与标签
- 📖 目录导航 (TOC)
- 🔍 代码高亮
- 🌙 自定义 404 页面
- 📱 移动端适配

## 📁 项目结构

```
my-blog/
├── source/
│   ├── _posts/          # 博客文章 (Post)
│   ├── about/           # 关于页面 (Page)
│   ├── css/             # 自定义样式
│   ├── img/             # 站点图片资源
│   └── images/          # 文章配图
├── scaffolds/           # 新建内容的模板
│   ├── post.md          # 文章模板
│   ├── draft.md         # 草稿模板
│   └── page.md          # 页面模板
├── themes/fluid/        # Fluid 主题（git 子模块）
├── _config.yml          # Hexo 主配置
├── _config.fluid.yml    # Fluid 主题配置
├── .github/             # GitHub 相关配置
│   └── COMMIT_CONVENTION.md
├── package.json         # 项目依赖
└── README.md            # 项目说明
```

## 🚀 快速开始

### 环境要求

- Node.js >= 12.0.0
- npm 或 yarn

### 安装与运行

```bash
# 克隆仓库（含子模块）
git clone --recurse-submodules https://github.com/canglang007/my-blog.git
cd my-blog

# 安装依赖
npm install

# 启动本地预览服务器（默认 http://localhost:4000）
npm run server
```

### 常用命令

| 命令 | 说明 |
|------|------|
| `npm run server` | 启动本地开发服务器 |
| `npm run build` | 生成静态文件到 `public/` |
| `npm run clean` | 清理已生成的静态文件 |
| `npm run deploy` | 部署到远程服务器 |

## ✍️ 写作指南

### Post（文章）vs Page（页面）

| | Post（文章） | Page（页面） |
|---|---|---|
| **存放位置** | `source/_posts/` | `source/页面名/index.md` |
| **用途** | 博客文章，按时间排列 | 独立页面（关于、标签页等） |
| **分类/标签** | ✅ 有 | ❌ 没有 |
| **出现在首页列表** | ✅ 会 | ❌ 不会 |
| **日期归档** | ✅ 会 | ❌ 不会 |
| **访问方式** | `blog.com/2025/04/25/标题/` | `blog.com/about/` |

### 新建内容

```bash
# 新建文章（使用 scaffolds/post.md 模板）
npx hexo new "文章标题"

# 新建草稿（不会显示在博客上，使用 scaffolds/draft.md 模板）
npx hexo new draft "还没写完的文章"

# 将草稿发布为正式文章
npx hexo publish "还没写完的文章"

# 新建页面（使用 scaffolds/page.md 模板）
npx hexo new page "tags"
```

### 模板（Scaffolds）

模板文件位于 `scaffolds/` 目录下，定义了 `hexo new` 时生成的默认 Front Matter。

可以创建自定义模板，如 `scaffolds/note.md`，然后通过 `npx hexo new note "标题"` 使用。

模板中支持的变量：
- `{{ title }}` — 创建时输入的标题
- `{{ date }}` — 创建时的当前时间

### Front Matter 字段说明

```yaml
---
title: 文章标题          # 标题
date: 2025-01-01 12:00:00  # 发布日期（创建时间）
updated: 2025-01-02 10:00:00  # 修改时间（不填则使用文件修改时间）
toc: true               # 是否显示目录
comments: true          # 是否开启评论
math: false             # 是否启用数学公式（KaTeX）
hide: false             # 是否从首页隐藏
excerpt: '文章摘要'      # 首页显示的摘要文字
categories: 分类名       # 文章分类
tags: [标签1, 标签2]     # 文章标签
---
```

> 💡 **关于修改时间**：如果不手动写 `updated` 字段，Hexo 会自动使用文件的最后修改时间。手动指定时更精确，适合只想在实质性修改时更新时间的情况。

## 🎨 主题管理

主题通过 git 子模块管理：

```bash
# 更新主题到最新版本
cd themes/fluid
git pull origin master
cd ../..

# 或使用 git submodule 命令
git submodule update --remote themes/fluid
```

主题配置在 `_config.fluid.yml` 中修改，不要直接修改 `themes/fluid/` 下的文件。

## 📝 提交规范

请参阅 [COMMIT_CONVENTION.md](.github/COMMIT_CONVENTION.md) 了解提交信息格式要求。

## 📄 许可证

MIT License
