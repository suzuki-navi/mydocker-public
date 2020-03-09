
export PATH=$HOME/bin2:$HOME/bin:$PATH

if [ -e $HOME/.pyenv/shims ]; then
    PATH="$HOME/.pyenv/shims:$HOME/.pyenv/bin":$PATH
fi

if [ -e $HOME/.mydocker/private/.zshenv ]; then
    source $HOME/.mydocker/private/.zshenv
fi

if [ -e $HOME/.mydocker/var/branch/.zshenv ]; then
    source $HOME/.mydocker/var/branch/.zshenv
fi

