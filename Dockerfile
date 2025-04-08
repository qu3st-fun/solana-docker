FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV TZ=UTC

# Install required libraries as root
USER root

RUN apt-get update && \
    apt-get install -y \
        curl \
        git \
        build-essential \
        pkg-config \
        libudev-dev \
        llvm \
        libclang-dev \
        protobuf-compiler \
        libssl-dev \
        cmake \
        python3 \
        python3-pip \
        wget \
        ca-certificates \
        xz-utils \
        unzip \
        sudo && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install solana libraries as ubuntu (default user)
USER ubuntu

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ENV PATH="/home/ubuntu/.cargo/bin:${PATH}"

RUN sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)"

ENV PATH="/home/ubuntu/.local/share/solana/install/active_release/bin:${PATH}"

RUN cargo install --git https://github.com/coral-xyz/anchor avm --force

RUN avm install latest && avm use latest



RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash && \
    export NVM_DIR="$HOME/.nvm" && \
    . "$NVM_DIR/nvm.sh" && \
    nvm install node && \
    npm install -g yarn


RUN echo 'export NVM_DIR="$HOME/.nvm"' >> $HOME/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> $HOME/.bashrc && \
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> $HOME/.bashrc

RUN mkdir /home/ubuntu/workspace

WORKDIR /home/ubuntu/workspace

CMD ["/bin/bash"]
