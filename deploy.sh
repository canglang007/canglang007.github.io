#!/bin/bash
hexo clean
hexo generate
git add .
default_msg="更新内容"

# 获取用户输入
read -p "请输入提交说明（默认: $default_msg）: " user_msg

# 使用默认值或用户输入
commit_msg="${user_msg:-$default_msg}"

git commit -m "$commit_msg"
git push origin main
hexo deploy