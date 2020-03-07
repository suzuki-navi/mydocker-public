FROM ubuntu:19.10

ARG HTTP_PROXY=
ARG HTTPS_PROXY=

RUN echo v2
RUN apt update

RUN apt install -y sudo zsh openssh-client openssh-server git gcc make curl less vim docker docker.io
RUN mkdir /run/sshd

ARG UID=9801
ARG USER=mydocker
RUN useradd -m -u ${UID} --groups sudo --shell /usr/bin/zsh ${USER}
RUN addgroup ${USER} docker
RUN echo '%sudo ALL=NOPASSWD: ALL' >> /etc/sudoers
ENV HOME=/home/${USER}

WORKDIR $HOME
USER ${USER}

ENV HTTP_PROXY=$HTTP_PROXY
ENV HTTPS_PROXY=$HTTPS_PROXY
RUN git config --global http.proxy "$HTTP_PROXY"
RUN git config --global https.proxy "$HTTPS_PROXY"

RUN sudo apt install -y locales-all
# perlで以下のwarningが出てしまうのを防ぐため
# perl: warning: Setting locale failed.
# perl: warning: Please check that your locale settings:
#         LANGUAGE = (unset),
#         LC_ALL = (unset),
#         LANG = "en_US.UTF-8"
#     are supported and installed on your system.
# perl: warning: Falling back to the standard locale ("C").

# python
RUN sudo apt install -y zlib1g-dev libffi-dev libssl-dev libsqlite3-dev libbz2-dev groff-base
RUN git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
ENV PYENV_ROOT=$HOME/.pyenv
ENV PATH=$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
RUN pyenv install --skip-existing -v 3.8.1
RUN pyenv global 3.8.1
RUN pip install --upgrade pip
#RUN pip install pipenv

# awscli
RUN pip install awscli awslogs

# 試行錯誤中

RUN sudo apt install -y zip postgresql-client-11 ncat dnsutils iputils-ping jq tmux moreutils

ADD var/.gitignore $HOME/.mydocker/var/.gitignore
ADD .gitignore     $HOME/.mydocker/.gitignore
ADD Dockerfile     $HOME/.mydocker/Dockerfile
ADD .zshenv        $HOME/.mydocker/.zshenv
ADD .zshrc         $HOME/.mydocker/.zshrc
ADD bin/           $HOME/.mydocker/bin/
ADD etc/           $HOME/.mydocker/etc/
ADD lib/           $HOME/.mydocker/lib/
ADD .git/          $HOME/.mydocker/.git/

USER root
RUN chown -R $USER:$USER $HOME/.mydocker
USER ${USER}

RUN ln -s $HOME/.mydocker/.zshenv $HOME/.zshenv
RUN ln -s $HOME/.mydocker/.zshrc  $HOME/.zshrc
RUN ln -s $HOME/.mydocker/bin     $HOME/bin

#CMD /usr/bin/zsh
CMD bash $HOME/.mydocker/lib/startup.sh zsh

