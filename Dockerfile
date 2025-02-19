FROM ubuntu:20.04

# Update system and add the packages required for Yocto builds.
# Use DEBIAN_FRONTEND=noninteractive, to avoid image build hang waiting
# for a default confirmation [Y/n] at some configurations.

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt install -y gawk wget git-core diffstat unzip texinfo \
    gcc-multilib build-essential chrpath socat cpio python python3 \
    python3-pip python3-pexpect xz-utils debianutils iputils-ping \
    libsdl1.2-dev xterm tar locales net-tools rsync sudo vim curl zstd \
    liblz4-tool libssl-dev bc lzop

# Set up locales
RUN locale-gen en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Set download directory for all build
ENV BB_ENV_PASSTHROUGH_ADDITIONS "DL_DIR SSTATE_DIR PARALLEL_MAKE BB_NUMBER_THREADS"
ENV DL_DIR /opt/yocto/downloads
ENV SSTATE_DIR /opt/yocto/sstate-cache
ENV PARALLEL_MAKE -j4
ENV BB_NUMBER_THREADS 8
# set processors to 10 in %UserProfile%/.wslconfig

# Yocto needs 'source' command for setting up the build environment, so replace
# the 'sh' alias to 'bash' instead of 'dash'.
RUN rm /bin/sh && ln -s bash /bin/sh

# Install repo
ADD https://storage.googleapis.com/git-repo-downloads/repo /usr/local/bin/
RUN chmod 755 /usr/local/bin/repo

# Add your user to sudoers to be able to install other packages in the container.
ARG USER
RUN echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER} && \
    chmod 0440 /etc/sudoers.d/${USER}

# Set the arguments for host_id and user_id to be able to save the build artifacts
# outside the container, on host directories, as docker volumes.
ARG host_uid \
    host_gid
RUN groupadd -g $host_gid nxp && \
    useradd -g $host_gid -m -s /bin/bash -u $host_uid $USER

# Yocto builds should run as a normal user.
USER $USER

ARG DOCKER_WORKDIR
WORKDIR ${DOCKER_WORKDIR}
