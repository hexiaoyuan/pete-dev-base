# 开发容器实例开启后的进一步设置

## 针对开发

### 修改apt源并更新

修改 /etc/apt/sources.list 到国内阿里云镜像:

```txt
deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
```

或者恢复出厂内容:

```txt
deb http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ focal-updates main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse
deb http://security.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse
```

或者修改为镜像方式:

sed -i 's#http://mirrors.aliyun.com/ubuntu/#mirror://mirrors.ubuntu.com/mirrors.txt#' /etc/apt/sources.list
sudo apt update
sudo apt dist-upgrade

如果需要使用socks5代理访问:
ssh -CNg -D 127.0.0.1:1082 myproxyhostname
sudo apt -o Acquire::http::proxy="socks5h://127.0.0.1:1082" update

### Install oh-my-zsh

sudo apt install zsh curl vim
chsh -s /bin/zsh  # 改你的默认shell,重新登陆生效后安装ohyzsh,然后修改配置:
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
vi ~/.zshrc

### 安装docker

根据官方网站文档安装最新版本：
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl gnupg
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io --no-install-recommends
sudo usermod -aG docker ubuntu

详情请参考: https://docs.docker.com/engine/install/ubuntu/

### 手工启动docker服务

sudo /etc/init.d/docker start

如果想重启docker是自动启动docker,可以把上面行加到 ~/.local/auto.sh 文件中去.
建议需要时开启即可，用完关掉省点资源.

### 安装aws工具

sudo apt --no-install-recommends --no-install-suggests install awscli
aws s3 ls

### 安装golang环境 (选择手动安装)

wget https://golang.org/dl/go1.17.2.linux-amd64.tar.gz
rm -rf ~/.local/go && tar -C ~/.local/ -xzf go1.17.2.linux-amd64.tar.gz
vi $HOME/.profile

```sh
export PATH=$PATH:$HOME/.local/go/bin:$HOME/go/bin
```

$ go version
$ go env

### 安装nodejs环境(选择手动安装)

NODEJS_VERSION=v14.18.0
wget https://nodejs.org/dist/$NODEJS_VERSION/node-$NODEJS_VERSION-linux-x64.tar.xz
tar -C ~/.local -xJvf node-$NODEJS_VERSION-linux-x64.tar.xz
cd ~/.local; rm -f nodejs; ln -s node-$NODEJS_VERSION-linux-x64 nodejs; cd -;
vi $HOME/.profile

```sh
export PATH=$PATH:$HOME/.local/nodejs/bin
```

$ node -v
$ npm version
$ npx -v

直接命令行运行:
$ npm install -g yarn

会安装到 /home/ubuntu/.local/nodejs/bin/yarn 本地目录，
下次升级nodejs后记得重新安装即可。

