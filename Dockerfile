#########
#
# docker build -f Dockerfile -t hexiaoyuan/pete-dev-base:latest .
#
# 基于 ubuntu-20.04+supervisor+sshd 用于开发的基础环境
#
# 注意：使用时不要apt更新系统，直接升级新的docker-image才对，因此个人开发环境
# 内容和工具请自己安装到自己目录下而不要安装到系统上。
#
#########


# Build Ubuntu image with base functionality.
FROM ubuntu:20.04 AS ubuntu-base

ENV container docker
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

#RUN sed -i 's#http://archive.ubuntu.com/ubuntu/#mirror://mirrors.ubuntu.com/mirrors.txt#' /etc/apt/sources.list;
RUN sed -i 's#archive.ubuntu.com#mirrors.aliyun.com#' /etc/apt/sources.list && sed -i 's#security.ubuntu.com#mirrors.aliyun.com#' /etc/apt/sources.list

# Install required tools ...
RUN apt-get -qq update && apt-get -qq -y dist-upgrade  \
    && apt-get -y -qq --no-install-recommends --no-install-suggests install \
        apt-utils sudo ca-certificates apt-transport-https gnupg curl wget \
    && apt-get -y -qq --no-install-recommends --no-install-suggests install \
        supervisor openssh-server python3 build-essential vim git lsb-release \
    && apt-get -y -qq --no-install-recommends --no-install-suggests install \
        zsh iputils-ping iproute2 htop elinks less tmux lsof
#
# clean if you want ...
RUN apt-get -qq clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
#
# Configure sudo.
RUN ex +"%s/^%sudo.*$/%sudo ALL=(ALL:ALL) NOPASSWD:ALL/g" -scwq! /etc/sudoers
#
# Configure SSHD.
#RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN bash -c 'install -m755 <(printf "#!/bin/sh\nexit 0") /usr/sbin/policy-rc.d' \
    && ex +'%s/^#\zeListenAddress 0.0.0.0/\1/g' -scwq /etc/ssh/sshd_config \
    && ex +'%s/^#\zeHostKey .*ssh_host_.*_key/\1/g' -scwq /etc/ssh/sshd_config \
    && ex +'%s/^#\zeUseDNS/\1/g' -scwq /etc/ssh/sshd_config \
    && sed -i 's!^#PasswordAuthentication yes!PasswordAuthentication no!' /etc/ssh/sshd_config
#
RUN RUNLEVEL=1 dpkg-reconfigure openssh-server
#RUN ssh-keygen -A -v
#RUN update-rc.d ssh defaults
#
# 删除掉生成的key在系统第一次启动时自动重新生成
RUN rm -f /etc/ssh/ssh_host_*key*
#
#
# 系统启动入口
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN  chmod +x /docker-entrypoint.sh
COPY 55-supervisord.conf /etc/supervisor/conf.d/55-supervisord.conf
#
#
# Setup the default user.
RUN groupadd --gid 1000 ubuntu
#  #  # --groups 'root,sudo,docker' 
RUN useradd --create-home --system -d /home/ubuntu -s /bin/zsh --uid 1000 --gid 1000 --groups 'root,sudo' ubuntu
RUN echo 'ubuntu:yourpasswd' | chpasswd
USER ubuntu
WORKDIR /home/ubuntu
#
# Generate and configure user keys.
USER ubuntu
RUN ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519
COPY --chown=ubuntu:ubuntu "./authorized_keys" /home/ubuntu/.ssh/authorized_keys
# Install oh-my-zsh
#RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
#
# 用户自定义启动脚本
COPY --chown=ubuntu:ubuntu auto.sh /home/ubuntu/.local/auto.sh
# RUN  chmod +x /home/ubuntu/.local/auto.sh
#
USER root
EXPOSE 22
# Setup default command and/or parameters.
#CMD ["sleep", "infinity"]
#CMD ["/usr/bin/sudo", "/usr/sbin/sshd", "-D", "-o", "ListenAddress=0.0.0.0"]
#CMD ["/usr/bin/supervisord"]
CMD ["/docker-entrypoint.sh"]

