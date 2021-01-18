# README
pete-dev-base 是个人开发用的基础 docker-image, 方便快速搭建开发环境.

基于 ubuntu:20.04 加上 sshd 和一些自己常用的开发工具，建议搭配
使用 vscode 装 ms-vscode-remote.remote-ssh 插件一起用.
通常可以一个项目一个本地容器，开发环境独立互不干扰.

+ 用户密码 ubuntu/ubuntu；默认zsh，并安装了oh-my-zsh，不喜勿扰。
+ 时区默认用UTC，如果要修改请重配tzdata，语言编码用 en_US.UTF-8 要改请重配 locales 即可。

## 编译发布
```
docker build -f Dockerfile -t hexiaoyuan/pete-dev-base:latest .
docker tag hexiaoyuan/pete-dev-base:latest hexiaoyuan/pete-dev-base:v20210118
docker push hexiaoyuan/pete-dev-base
```

## 本地开启一个容器实例
```
docker push hexiaoyuan/pete-dev-base
docker run -d --init --privileged -p 50990:22 --name pete02 hexiaoyuan/pete-dev-base
```

## 进入
```
docker exec -it pete02 bash

##进入后先把秘密改一下(ubuntu/ubuntu):
ubuntu@886ec2d5325f:~$ passwd
Changing password for ubuntu.
Current password:
New password:
Retype new password:

##把需要的key加入：
$ vi /home/ubuntu/.ssh/authorized_keys

##根据自己需求调整zsh的配置
$ vi ~/.zshrc

$ exit

```

## 远程
```
ssh ubuntu@127.0.0.1 -p 50990
```

