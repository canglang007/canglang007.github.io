---
title: git本地版本回退
toc: true
comments: valine
math: false
hide: false
excerpt: '因为本人在今天写博客的时候不慎将远程的东西全部覆盖到本地了，然后本地有一些写在gitignore中的文件以及文件夹就都没了，吓了一跳，于是乎就想着怎么把本地版本回退到正常的版本，于是乎就找到了git相关的一些命令。'
date: 2025-03-19 16:11:47
categories: 开发经验
---

## 1. 默认的 git reflog 输出

直接运行命令：

```Shell
import numpy as np
```

输出示例：

```Shell
abc1234 (HEAD -> main) HEAD@{0}: pull origin main: Fast-forward
def5678 HEAD@{1}: commit: 修复登录页面样式
ghi9012 HEAD@{2}: reset: moving to HEAD~1
```

* 时间信息：默认不直接显示时间，但可以通过 HEAD@{n} 的时间引用（如 HEAD@{5.minutes.ago}）间接表示。

## 2.显示完整的时间戳

```
git reflog --date=iso
```

输出示例：

```
abc1234 (HEAD -> main) HEAD@{2023-10-01 15:30:00 +0800}: pull origin main
def5678 HEAD@{2023-10-01 14:20:00 +0800}: commit: 修复登录页面样
```

## &#x20;3. 其他时间格式

* --date=relative：显示相对时间（如「2 hours ago」）

* --date=local：本地时间格式

* --date=unix：Unix 时间戳
  示例：

```
git reflog --date=relative
```

输出：

```
abc1234 (HEAD -> main) HEAD@{5 minutes ago}: pull origin main
def5678 HEAD@{2 hours ago}: commit: 修复登录页面样式
```

## 4. 关键点

* 时间范围：git reflog 默认保留 90 天内的操作记录（可通过配置调整）。

* 恢复依据：通过时间戳或 HEAD@{n} 定位到误操作前的提交，然后回退：

  ```
  git reset --hard HEAD@{5.min
  # 或者：
  git reset --hard abc1234
  ```

* 退出git reflog界面：按q即可



