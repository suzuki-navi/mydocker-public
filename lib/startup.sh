
if [ -e $HOME/.mydocker/var/host ]; then
    :
elif [ -e /md ]; then
    sudo chmod 777 /md/var
    ln -s /md/var $HOME/.mydocker/var/host
else
    mkdir -p $HOME/.mydocker/var/host
fi

bash $HOME/.mydocker/lib/extract-credentials.sh
bash $HOME/.mydocker/lib/sync-private.sh

sudo /usr/sbin/sshd

if [ "$*" = "zsh" ]; then
    zsh
    $HOME/.mydocker/bin/sync-mydocker
    r=$?
    if [ $r != 0 ]; then
        zsh
    fi
elif [ "$#" != 0 ]; then
    "$@"
fi

