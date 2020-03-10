
set -Ceu

if [ ! -e $HOME/.mydocker/var/packages/xsvutils ]; then (
    mkdir -p $HOME/.mydocker/var/packages/xsvutils
    cd $HOME/.mydocker/var/packages/xsvutils

    sudo apt update
    sudo apt install bsdmainutils
    git clone https://github.com/suzuki-navi/xsvutils.git .
    make
); fi

if [ ! -e $HOME/bin2/xsvutils ]; then
    ln -s $HOME/.mydocker/var/packages/xsvutils/xsvutils $HOME/bin2/xsvutils
fi

