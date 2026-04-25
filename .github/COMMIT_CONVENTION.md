# 提交信息规范

## 格式

提交信息应该遵循以下格式：

```
<type>: <subject>

<body>
```

## 提交类型 (type)

- **feat**: 新功能
- **fix**: 修复bug
- **docs**: 文档更新
- **style**: 代码格式调整（不影响功能）
- **refactor**: 代码重构
- **test**: 测试相关
- **chore**: 构建过程或辅助工具变动
- **perf**: 性能优化

## 主题 (subject)

- 使用祈使句，现在时态："change" 而不是 "changed" 或 "changes"
- 首字母不大写
- 末尾不加句号
- 长度不超过50个字符

## 正文 (body)

- 说明修改的原因和细节
- 使用祈使句，现在时态
- 每行不超过72个字符
- 空行分隔主题和正文

## 示例

```
feat: add user authentication system

- Implement JWT token based authentication
- Add login/logout endpoints
- Create user model and migration
```

```
fix: resolve image loading issue in safari

- Update image lazy loading implementation
- Add browser compatibility checks
- Fix CSS display issues on mobile
```