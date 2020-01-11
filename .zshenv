
export PATH=$HOME/bin:$PATH

if [ -e $HOME/.pyenv/shims ]; then
    PATH="$HOME/.pyenv/shims":$PATH
fi

if [ -e $HOME/.mydocker/private/.zshenv ]; then
    source $HOME/.mydocker/private/.zshenv
fi

