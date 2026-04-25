# My Personal Blog

个人博客，基于 Hexo 和 Fluid 主题构建。

## 项目结构

```
my-blog/
├── source/          # 文章和页面源文件
├── themes/fluid/    # Fluid 主题（git 子模块）
├── public/          # 生成的静态文件（已忽略）
├── .gitignore       # Git 忽略规则
├── package.json     # 项目依赖
└── README.md        # 项目说明
```

## 开发环境设置

1. 安装 Node.js (>= 12.0.0)
2. 安装 Hexo: `npm install -g hexo-cli`
3. 安装依赖: `npm install`

## 常用命令

- `npm run server` - 启动本地服务器
- `npm run build` - 生成静态文件
- `npm run clean` - 清理生成的文件
- `npm run deploy` - 部署到服务器

## 主题管理

主题使用 git 子模块管理，更新主题：

```bash
cd themes/fluid
git pull origin master
```

## 许可证

MIT License