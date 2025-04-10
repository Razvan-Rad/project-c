FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y build-essential git && \
    apt-get install -y nano neovim && \
    apt-get install ripgrep && \
    apt-get clean
WORKDIR /project
COPY nvim_config ~/.config
RUN /bin/bash