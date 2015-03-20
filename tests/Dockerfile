FROM python:2
MAINTAINER Julian Berman <Julian+Dotfiles@GrayVines.com>

RUN apt-get update
RUN apt-get install -y zsh

RUN pip install --quiet green
RUN git clone --recursive https://github.com/Julian/dotfiles ${HOME}/.dotfiles
RUN ${HOME}/.dotfiles/dot install

ADD . $HOME/.dotfiles/tests
WORKDIR $HOME/.dotfiles/tests
CMD green tests
