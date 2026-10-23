# docker/dockerfile:1
FROM debian:trixie-slim

ARG TARGETARCH
ARG NODE_VERSION=24.11.0
ARG USERNAME=dev
ARG UID=1000
ARG GID=1000

ENV DEBIAN_FRONTEND=noninteractive \
    TERM=xterm-256color \
    COLORTERM=truecolor \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# System requirements
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates curl wget git sudo unzip xz-utils tar gzip \
        build-essential make gcc g++ \
        ripgrep fd-find tmux less procps iputils-ping net-tools \
    && ln -s "$(command -v fdfind)" /usr/local/bin/fd \
    && rm -rf /var/lib/apt/lists/*

# PHP
RUN apt-get update && apt-get install -y --no-install-recommends \
        php-cli php-curl php-mbstring php-xml php-zip php-sqlite3 composer \
    && rm -rf /var/lib/apt/lists/*

# Python
RUN apt-get update && apt-get install -y --no-install-recommends \
        python3 python3-pip python3-venv python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Bash tooling
RUN apt-get update && apt-get install -y --no-install-recommends \
        shellcheck shfmt \
    && rm -rf /var/lib/apt/lists/*

# Node.js
RUN case "${TARGETARCH}" in \
        amd64) NODE_ARCH=x64 ;; \
        arm64) NODE_ARCH=arm64 ;; \
        *) echo "Error: Unsopported architecture ${TARGETARCH}" && exit 1 ;; \
    esac \
    && curl -fsSL "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${NODE_ARCH}.tar.xz" \
        | tar -xJ -C /usr/local --strip-components=1 \
    && node --version && npm --version

# Neovim
RUN case "${TARGETARCH}" in \
        amd64) NVIM_ARCH=x86_64 ;; \
        arm64) NVIM_ARCH=arm64 ;; \
        *) echo "Error: Unsupported architecture ${TARGETARCH}" && exit 1 ;; \
    esac \
    && curl -fsSL "https://github.com/neovim/neovim/releases/download/stable/nvim-linux-${NVIM_ARCH}.tar.gz" \
        | tar -xz -C /opt \
    && ln -s "/opt/nvim-linux-${NVIM_ARCH}/bin/nvim" /usr/local/bin/nvim \
    && nvim --version | head -n 1

# sudo config
RUN (getent group ${GID} || groupadd -g ${GID} ${USERNAME}) \
    && useradd -m -u ${UID} -g ${GID} -s /bin/bash ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

USER ${USERNAME}
WORKDIR /home/${USERNAME}

# NvChad
RUN git clone --depth 1 https://github.com/NvChad/starter ~/.config/nvim \
    && nvim --headless "+Lazy! sync" +qa \
    && nvim --headless "+TSUpdateSync" +qa || true

RUN echo 'alias vi=nvim\nalias vim=nvim\nexport EDITOR=nvim' >> ~/.bashrc

# Workspace
RUN mkdir -p /home/${USERNAME}/workspace
WORKDIR /home/${USERNAME}/workspace
EXPOSE 8081
CMD ["sleep", "infinity"]
