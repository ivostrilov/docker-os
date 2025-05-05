FROM oraclelinux:9

# Basic utilities:
#   - ncurses contains clear.
RUN dnf install -y \
  bash-completion \
  cmake \
  git \
  nc \
  ncurses \
  sudo \
  wget \
  which \
  xz

# EPEL (Extra Packages for Enterprise Linux)
RUN dnf install -y oracle-epel-release-el9

# RU locale
RUN dnf install -y glibc-langpack-ru

# CPP
RUN sudo dnf install -y \
  gcc-c++ \
  glibc-devel \
  libstdc++-devel

# Python
RUN dnf install -y dnf-utils && \
  dnf install -y python3.11 && \
  dnf clean all

RUN alternatives --install \
  /usr/bin/python3 python3 /usr/bin/python3.11 1 && \
  alternatives --set python3 /usr/bin/python3.11

# Bash LSP
RUN dnf module install -y nodejs:22 && \
  npm install -g bash-language-server
RUN dnf install -y shellcheck

RUN useradd -m -s /bin/bash i.vostrilov && \
  echo "i.vostrilov:hello" | chpasswd && \
  echo "i.vostrilov ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ARG USER_DIR=/home/i.vostrilov
ARG USER_BIN=/home/i.vostrilov/bin
ARG MY_PACKAGES=/home/i.vostrilov/my-packages

COPY rootfs /
RUN chown i.vostrilov:i.vostrilov -R "$USER_DIR" && chmod -R 755 "$USER_DIR"

USER i.vostrilov
WORKDIR $USER_DIR

# If putted llvm to the $MY_PACKAGES.
# Download url:
# https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.2/LLVM-20.1.2-macOS-ARM64.tar.xz
# RUN tar -xf "$MY_PACKAGES/LLVM-20.1.2-Linux-ARM64.tar.xz" -C "$MY_PACKAGES/"

# Font
RUN sudo dnf install -y fontconfig
RUN mkdir -p "$USER_DIR/.local/share/fonts/"
RUN cp "$MY_PACKAGES/jetbrains-mono-nerd-font/"*.ttf \
  "$USER_DIR/.local/share/fonts/"

RUN mkdir $USER_DIR/bin

# Pip3
RUN curl https://bootstrap.pypa.io/get-pip.py -o "$MY_PACKAGES/get-pip.py"
RUN python3 "$MY_PACKAGES/get-pip.py"

# CPP check code style
RUN "$USER_DIR/.local/bin/pip3" install cpplint

# Poertry
RUN curl -sSL https://install.python-poetry.org | python3 -

# Python LSP
RUN python3 -m venv dev-venv
RUN "$USER_DIR/dev-venv/bin/pip" install --upgrade pip && \
  "$USER_DIR/dev-venv/bin/pip" install \
  python-lsp-server \
  python-lsp-black \
  pyflakes \
  black

RUN fc-cache -fv

# Tmux
RUN sudo dnf install -y tmux
RUN git clone https://github.com/tmux-plugins/tpm "$USER_DIR/.tmux/plugins/tpm"

# Neovim
RUN tar -xvf "$MY_PACKAGES/neovim/nvim-linux-arm64.tar" \
  -C "$MY_PACKAGES/neovim"

RUN ln -s "$MY_PACKAGES/neovim/nvim-linux-arm64/bin/nvim" "$USER_BIN/nvim"

# Neovim dependecies
RUN sudo dnf install ripgrep luarocks

# Uncomment if putted ssh keys to rootfs
# RUN chmod 400 "$USER_DIR/.ssh/id_rsa" "$USER_DIR/.ssh/id_rsa.pub"

ARG NEOVIM_CONFIG_REPO_URL="https://github.com/ivostrilov/custom-neovim.git"
# ARG NEOVIM_CONFIG_REPO_URL="git@github.com:ivostrilov/custom-neovim.git"

# Neovim config
RUN mkdir -p $USER_DIR/.config && \
  ssh-keyscan github.com >> ~/.ssh/known_hosts && \
  git clone "$NEOVIM_CONFIG_REPO_URL" \
  "$USER_DIR/.config/nvim"

ARG NEOVIM_LSP_CONFIG=$USER_DIR/.config/nvim/lua/plugins/lsp.lua
RUN sed -i 's/bashls = false/bashls = true/' $NEOVIM_LSP_CONFIG
RUN sed -i 's/pylsp = false/pylsp = true/' $NEOVIM_LSP_CONFIG
RUN sed -i 's/clangd = false/clangd = true/' $NEOVIM_LSP_CONFIG

CMD tail -f /dev/null
