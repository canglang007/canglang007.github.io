#!/bin/bash
hexo clean
hexo generate
git add .
git commit -m "更新内容"
git push origin main
hexo deploy