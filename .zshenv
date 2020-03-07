
export PATH=$HOME/bin:$PATH

if [ -e $HOME/.pyenv/shims ]; then
    PATH="$HOME/.pyenv/shims:$HOME/.pyenv/bin":$PATH
fi

if [ -e $HOME/.mydocker/var/branch/.zshenv ]; then
    source $HOME/.mydocker/private/.zshenv
fi

