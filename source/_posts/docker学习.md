---
title: docker学习
toc: true
comments: valine
math: false
hide: false
excerpt: '近期在帮助别人运行一个github项目的时候，发现它支持的一些包的版本非常老；在windows和虚拟机（Ubuntu16.04）下搭建环境都很麻烦，本人用的虚拟机是VMware，但是搜了一下发现好像虚拟机使用windows系统的cuda什么的不是很方便，所以考虑用docker跑一下；之前是学过一点点docker的，但是就跑了个demo没实际跑过项目，正好发现github的issue里面有人发了他搭建的docker镜像，所以考虑试试'
date: 2025-04-11 22:44:51
categories: 开发经验
tags: [Docker, 容器, 开发环境, GPU]
---

## 背景

近期在帮助别人运行一个 GitHub 项目的时候，发现它依赖的一些包版本非常老，在 Windows 和虚拟机（Ubuntu 16.04）下搭建环境都很麻烦。本人用的虚拟机是 VMware，搜了一下发现虚拟机使用 Windows 系统的 CUDA 不是很方便，所以考虑用 Docker 来跑。

之前学过一点点 Docker，但只是跑了个 demo 没实际跑过项目。正好发现 GitHub 的 issue 里有人发了他搭建的 Docker 镜像，所以考虑试试。

## Docker 基础概念

### 什么是 Docker？

Docker 是一个容器化平台，可以将应用程序及其依赖打包到一个隔离的容器中运行。对于我们搞深度学习和跑 GitHub 项目来说，最大的好处就是**不用担心环境冲突**。

### 核心概念

- **镜像 (Image)**：一个只读的模板，包含了运行应用所需的所有东西（代码、运行时、库、环境变量等）
- **容器 (Container)**：镜像的运行实例，可以被启动、停止、删除
- **Dockerfile**：构建镜像的脚本文件
- **Docker Hub**：公共镜像仓库，可以拉取别人做好的镜像

简单类比：**镜像**就像一个操作系统的 ISO 文件，**容器**就像用这个 ISO 安装后运行的虚拟机。

## Docker 安装

### Windows (WSL2 + Docker Desktop)

1. 确保 WSL2 已经安装并启用
2. 下载 [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/)
3. 安装时勾选 "Use WSL 2 instead of Hyper-V"
4. 安装完成后重启，Docker Desktop 会自动与 WSL2 集成

验证安装：

```bash
docker --version
docker run hello-world
```

### Linux (Ubuntu)

```bash
# 卸载旧版本
sudo apt-get remove docker docker-engine docker.io containerd runc

# 安装依赖
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg lsb-release

# 添加 Docker 官方 GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# 添加仓库
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 安装 Docker
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 将当前用户加入 docker 组（免 sudo）
sudo usermod -aG docker $USER
```

> ⚠️ 加入 docker 组后需要重新登录终端才能生效。

## Docker 常用命令

### 镜像管理

```bash
# 拉取镜像
docker pull ubuntu:20.04
docker pull pytorch/pytorch:1.9.0-cuda11.1-cudnn8-devel

# 查看本地镜像
docker images

# 删除镜像
docker rmi <image_id>
```

### 容器管理

```bash
# 运行容器（交互式）
docker run -it ubuntu:20.04 /bin/bash

# 后台运行容器
docker run -d --name my_container ubuntu:20.04

# 查看正在运行的容器
docker ps

# 查看所有容器（包括已停止的）
docker ps -a

# 进入正在运行的容器
docker exec -it <container_id> /bin/bash

# 停止/启动/重启容器
docker stop <container_id>
docker start <container_id>
docker restart <container_id>

# 删除容器
docker rm <container_id>
```

### 数据挂载

将宿主机的目录挂载到容器中，方便代码和数据共享：

```bash
# -v 宿主机路径:容器内路径
docker run -it -v /home/user/project:/workspace ubuntu:20.04 /bin/bash
```

## 使用 Docker 运行 GPU 项目（重点）

这是我这次实践的核心内容。很多深度学习项目需要 GPU 加速，Docker 配合 NVIDIA Container Toolkit 可以完美解决这个问题。

### 安装 NVIDIA Container Toolkit

前提：宿主机已经安装了 NVIDIA 驱动。

```bash
# 添加仓库
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/libnvidia-container/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# 安装
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit

# 重启 Docker
sudo systemctl restart docker
```

### 运行 GPU 容器

```bash
# 使用所有 GPU
docker run --gpus all -it pytorch/pytorch:1.9.0-cuda11.1-cudnn8-devel /bin/bash

# 指定 GPU
docker run --gpus '"device=0"' -it pytorch/pytorch:1.9.0-cuda11.1-cudnn8-devel /bin/bash

# 验证 GPU 可用
nvidia-smi
python -c "import torch; print(torch.cuda.is_available())"
```

### 实际操作：使用 Issue 中提供的镜像运行项目

这是我实际的操作流程：

```bash
# 1. 拉取 issue 中提供的镜像
docker pull <username>/<image_name>:<tag>

# 2. 运行容器，挂载项目代码，启用 GPU
docker run --gpus all -it \
  -v /path/to/project:/workspace \
  -v /path/to/data:/data \
  --shm-size=8g \
  <username>/<image_name>:<tag> \
  /bin/bash

# 3. 在容器内运行项目
cd /workspace
python train.py --config config.yaml
```

> 💡 `--shm-size=8g` 很重要！PyTorch 的 DataLoader 使用共享内存，默认的 64MB 经常会导致 "out of shared memory" 错误。

## 常见问题与踩坑记录

### 1. 容器内无法使用 GPU

**现象**：`nvidia-smi` 报错或 `torch.cuda.is_available()` 返回 False

**排查步骤**：
```bash
# 宿主机确认驱动正常
nvidia-smi

# 确认 nvidia-container-toolkit 已安装
dpkg -l | grep nvidia-container

# 确认 Docker runtime 配置正确
cat /etc/docker/daemon.json
```

**daemon.json 应该包含**：
```json
{
    "runtimes": {
        "nvidia": {
            "path": "nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
```

### 2. 权限问题

容器内默认是 root 用户，但挂载的文件可能存在权限冲突：

```bash
# 以指定用户运行
docker run --user $(id -u):$(id -g) -it ...

# 或者在容器内修改权限
chmod -R 777 /workspace
```

### 3. 容器退出后数据丢失

容器内产生的数据如果没有挂载到宿主机，停止容器后就丢失了。解决方法：

```bash
# 方法1：使用 -v 挂载（推荐）
docker run -v /host/results:/container/results ...

# 方法2：从停止的容器中复制文件
docker cp <container_id>:/path/to/file /host/path

# 方法3：提交为新镜像
docker commit <container_id> my_project:with_results
```

### 4. 镜像太大，下载慢

使用国内镜像加速器：

```bash
# 编辑 /etc/docker/daemon.json
{
    "registry-mirrors": [
        "https://mirror.ccs.tencentyun.com",
        "https://hub-mirror.c.163.com"
    ]
}

# 重启 Docker
sudo systemctl daemon-reload
sudo systemctl restart docker
```

### 5. 端口映射

如果项目需要开放端口（比如 TensorBoard、Jupyter）：

```bash
# -p 宿主机端口:容器端口
docker run -p 8888:8888 -p 6006:6006 --gpus all -it my_image /bin/bash

# 容器内启动 Jupyter
jupyter notebook --ip=0.0.0.0 --port=8888 --allow-root
```

## Dockerfile 编写示例

如果你需要自己构建镜像，下面是一个深度学习项目的 Dockerfile 示例：

```dockerfile
# 基于 PyTorch 官方镜像
FROM pytorch/pytorch:1.9.0-cuda11.1-cudnn8-devel

# 设置工作目录
WORKDIR /workspace

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    git \
    vim \
    wget \
    && rm -rf /var/lib/apt/lists/*

# 复制项目依赖文件
COPY requirements.txt .

# 安装 Python 依赖
RUN pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# 复制项目代码
COPY . .

# 默认命令
CMD ["/bin/bash"]
```

构建并运行：

```bash
docker build -t my_project:v1 .
docker run --gpus all -it my_project:v1 /bin/bash
```

## 总结

Docker 对于解决**环境依赖冲突**问题非常有效，特别是：
- 项目依赖的包版本很老，和当前系统不兼容
- 需要特定版本的 CUDA/cuDNN
- 多个项目的环境互相冲突

核心工作流就是：**找到/构建合适的镜像 → 挂载代码和数据 → 启用 GPU → 在容器内运行**。

对于 GitHub 上的开源项目，很多作者或者社区贡献者会提供现成的 Docker 镜像或 Dockerfile，善用 Issues 搜索往往能找到。
