FROM ubuntu:16.04

ENV TERM xterm
ENV DEBIAN_FRONTEND noninteractive

# These are assumed to be installed by default by the user
RUN apt-get update && apt-get install -y sudo git software-properties-common && \
    apt update

# Setup a developer account
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer
ENV HOME /home/developer

# Install base dependencies
ADD . /home/developer/status
WORKDIR /home/developer/status
RUN scripts/setup

# Add support for adb
RUN apt install android-tools-adb

# Move cached deps to developer account
RUN chown -R developer:developer /home/developer
USER developer
