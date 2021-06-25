# README

pete-dev-base 是个人开发用的基础 docker-image, 方便快速搭建开发环境.

基于 ubuntu:20.04 加上 supervisor+sshd 和一些自己常用的开发工具，建议搭配使用 vscode 装 ms-vscode-remote.remote-ssh 插件一起用.
通常可以一个项目一个本地容器，开发环境独立互不干扰.

+ 用户密码 ubuntu/yourpasswd; 默认zsh，建议自己安装oh-my-zsh，不喜勿扰。
+ 时区默认用 UTC，如果要修改请重配tzdata，语言编码用 en_US.UTF-8 要改请重配 locales 即可。

## 编译发布

```sh
touch authorized_keys
docker build -f Dockerfile -t hexiaoyuan/pete-dev-base:latest .
docker tag hexiaoyuan/pete-dev-base:latest hexiaoyuan/pete-dev-base:v20210625
docker push hexiaoyuan/pete-dev-base -a
```

## 本地开启一个容器实例

```sh
docker pull hexiaoyuan/pete-dev-base
docker run -it --rm --init -p 60102:22 --name pete02 --hostname pete02 hexiaoyuan/pete-dev-base

#### 记录一些参数，以后在测试
docker run -d \
  --init \
  --privileged `#optional` \
  -v /var/run/docker.sock:/var/run/docker.sock `#optional` \
  -v /sys/fs/cgroup:/sys/fs/cgroup:ro `#optional`\
  --cap-add=SYS_ADMIN --env container=docker`#optional` \
  --tmpfs /tmp --tmpfs /run --tmpfs /run/lock `#optional`\
  --shm-size="1gb" `#optional` \
  -p 60102:22 \
  --name pete02 --hostname pete02 hexiaoyuan/pete-dev-base

#
# 开发测试时：
docker run --rm -it \
  -e=container=docker -e LANG=C.UTF-8  \
  --tmpfs /tmp --tmpfs /run --tmpfs /run/lock \
  -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
  -p 60102:22  ubuntu:20.04

```

## 进入

```txt
$ docker exec -it pete02 zsh

pete02# passwd ubuntu
New password:
Retype new password:
passwd: password updated successfully
pete02#

##把需要的key加入：
# su - ubuntu
$ vi /home/ubuntu/.ssh/authorized_keys

##根据自己需求调整zsh的配置
$ vi ~/.zshrc

$ exit

```

## 远程

```sh
ssh ubuntu@127.0.0.1 -p 60102
```

## 使用 volume 来保存数据(建议)

```sh
docker volume create vol_pete02_home
docker volume inspect vol_pete02_home

docker run -d --init \
  -p 60102:22 \
  --mount source=vol_pete02_home,target=/home \
  --name pete02 --hostname pete02 hexiaoyuan/pete-dev-base:v20210625

docker exec -it pete02 zsh

```
