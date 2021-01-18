# pete-dev-base
pete-dev-base: base docker image for my dev

# README
基于 ubuntu:20.04 加上了sshd方便vscode进行登陆开发，同时加了一些自己常用的工具如：
nodejs，python3，gcc，vim 等等。

+ 用户密码 ubuntu/ubuntu；默认zsh，并安装了oh-my-zsh，不喜勿扰。
+ 时区默认用UTC，如果要修改请重配tzdata，语言编码用 en_US.UTF-8 要改请重配 locales 即可。

## 编译
```
docker build -f Dockerfile -t hexiaoyuan/pete-dev-base .
```

## 开启
```
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
$vi /home/ubuntu/.ssh/authorized_keys

$ exit

```

## 远程
```
ssh ubuntu@127.0.0.1 -p 50990
```
