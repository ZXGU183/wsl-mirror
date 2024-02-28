#!/bin/bash

# change apt source
# comment all active lines in the apt source file
sudo sed -i -e 's/^deb/#deb/' /etc/apt/sources.list

# https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/
# append tsinghua apt source to the apt source file
sudo sed -i -e "$ a\\
\n# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释\n\
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse\n\
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse\n\
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse\n\
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse\n\
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse\n\
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse\n\
\n\
deb http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse\n\
# deb-src http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse\n\
\n\
# 预发布软件源，不建议启用\n\
# deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse\n\
# # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse" \
/etc/apt/sources.list

# update the package index files and upgrade packages
sudo apt update && sudo apt -y upgrade

# https://learn.microsoft.com/en-us/windows/python/web-frameworks
# only upgrade python3 here
sudo apt -y upgrade python3

# install pip
sudo apt -y install python3-pip

# https://mirrors.tuna.tsinghua.edu.cn/help/pypi/
# change to tsinghua pip source
pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# install venv
sudo apt -y install python3-venv

# https://learn.microsoft.com/en-us/windows/dev-environment/javascript/nodejs-on-wsl
# install curl
sudo apt -y install curl

# https://gitee.com/mirrors/nvm
# install nvm
curl -o- https://gitee.com/mirrors/nvm/raw/master/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# https://github.com/nvm-sh/nvm?tab=readme-ov-file#install--update-script
# write activation script to .bash_profile to auto-start nvm
echo -e \
"export NVM_DIR=\"\$([ -z \"\${XDG_CONFIG_HOME-}\" ] && printf %s \"\${HOME}/.nvm\" || printf %s \"\${XDG_CONFIG_HOME}/nvm\")\"\
\n[ -s \"\$NVM_DIR/nvm.sh\" ] && \\. \"\$NVM_DIR/nvm.sh\" # This loads nvm" \
> ~/.bash_profile

# install node in nvm
nvm install --lts
nvm use --lts

# https://npmmirror.com/
# change to ali npm source
npm config set registry https://registry.npmmirror.com

# If you need to use GPU CUDA on WSL
# https://github.com/microsoft/WSL/issues/5663#issuecomment-760679748
#sudo ln -s /usr/lib/wsl/lib/libcuda.so.1 /usr/local/cuda/lib64/libcuda.so
