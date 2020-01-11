FROM ubuntu:19.10

RUN echo v1
RUN apt update

RUN apt install -y sudo zsh git gcc make curl less vim

ARG UID=9801
ARG USER=mydocker
RUN useradd -m -u ${UID} --groups sudo ${USER}
RUN echo '%sudo ALL=NOPASSWD: ALL' >> /etc/sudoers
ENV HOME=/home/${USER}

WORKDIR $HOME
USER ${USER}

# python
RUN sudo apt install -y zlib1g-dev libffi-dev libssl-dev libsqlite3-dev libbz2-dev groff-base
RUN git clone git://github.com/pyenv/pyenv.git $HOME/.pyenv
ENV PYENV_ROOT=$HOME/.pyenv
ENV PATH=$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
RUN pyenv install --skip-existing -v 3.8.1
RUN pyenv global 3.8.1
RUN pip install --upgrade pip
#RUN pip install pipenv

# awscli
RUN pip install awscli

ADD var/.gitignore $HOME/.mydocker/var/.gitignore
ADD .gitignore     $HOME/.mydocker/.gitignore
ADD Dockerfile     $HOME/.mydocker/Dockerfile
ADD .zshenv        $HOME/.mydocker/.zshenv
ADD .zshrc         $HOME/.mydocker/.zshrc
ADD bin/           $HOME/.mydocker/bin/
ADD lib/           $HOME/.mydocker/lib/
ADD .git/          $HOME/.mydocker/.git/

USER root
RUN chown -R $USER:$USER $HOME/.mydocker
USER ${USER}

RUN ln -s $HOME/.mydocker/.zshenv $HOME/.zshenv
RUN ln -s $HOME/.mydocker/.zshrc  $HOME/.zshrc
RUN ln -s $HOME/.mydocker/bin     $HOME/bin

#CMD /usr/bin/zsh
CMD bash $HOME/.mydocker/lib/startup.sh

