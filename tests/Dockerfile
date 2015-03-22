FROM debian:testing
MAINTAINER Julian Berman <Julian+Dotfiles@GrayVines.com>

RUN apt-get update
RUN apt-get install -y git python-pip vim-nox zsh

RUN python -m pip install --quiet green
RUN git clone --recursive https://github.com/Julian/dotfiles /root/.dotfiles
RUN /root/.dotfiles/dot install

ADD . /root/.dotfiles/tests
WORKDIR /root/.dotfiles/tests
CMD green tests
