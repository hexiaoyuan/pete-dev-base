# Build Ubuntu image with base functionality.
FROM ubuntu:20.04 AS ubuntu-base
ENV DEBIAN_FRONTEND noninteractive
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required tools: sshd,vim,gcc,python3,nodejs,yarn
RUN apt-get -qq update && apt-get -qq -y dist-upgrade  && apt-get -y -qq --no-install-recommends install \
    sudo git vim python3 build-essential openssh-server \
    curl wget ca-certificates openssl lsb-release gnupg \
    bsdmainutils lsof iputils-ping iproute2 htop \
    tzdata locales tmux zsh
#RUN apt-get -qq clean && rm -rf /var/lib/apt/lists/*
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
#
# Install nodejs and yarn
RUN curl -sL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
RUN sudo apt-get update && sudo apt-get -qq install -y yarn nodejs
#
# clean if you want
RUN apt-get -qq clean && rm -rf /var/lib/apt/lists/*
#
# Configure sudo.
RUN ex +"%s/^%sudo.*$/%sudo ALL=(ALL:ALL) NOPASSWD:ALL/g" -scwq! /etc/sudoers
# Configure SSHD.
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN mkdir /var/run/sshd
RUN bash -c 'install -m755 <(printf "#!/bin/sh\nexit 0") /usr/sbin/policy-rc.d'
RUN ex +'%s/^#\zeListenAddress/\1/g' -scwq /etc/ssh/sshd_config
RUN ex +'%s/^#\zeHostKey .*ssh_host_.*_key/\1/g' -scwq /etc/ssh/sshd_config
RUN RUNLEVEL=1 dpkg-reconfigure openssh-server
RUN ssh-keygen -A -v
RUN update-rc.d ssh defaults
#
# Setup the default user.
RUN groupadd --gid 1000 ubuntu
RUN useradd --create-home --system -d /home/ubuntu -s /bin/zsh --uid 1000 --gid 1000 --groups 'root,sudo' ubuntu
RUN echo 'ubuntu:ubuntu' | chpasswd
USER ubuntu
WORKDIR /home/ubuntu
#
# Generate and configure user keys.
USER ubuntu
RUN ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519
#COPY --chown=ubuntu:ubuntu "./authorized_keys" /home/ubuntu/.ssh/authorized_keys
# Install oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
#
# Setup default command and/or parameters.
EXPOSE 22
#CMD ["sleep", "infinity"]
CMD ["/usr/bin/sudo", "/usr/sbin/sshd", "-D", "-o", "ListenAddress=0.0.0.0"]
