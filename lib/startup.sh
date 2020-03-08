
if [ -e $HOME/.mydocker/var/host ]; then
    :
elif [ -e /md ]; then
    sudo chmod 777 /md/var
    sudo chmod 666 /md/etc/known_hosts
    ln -s /md/var $HOME/.mydocker/var/host
else
    mkdir -p $HOME/.mydocker/var/host
fi

touch $HOME/.mydocker/var/config

bash $HOME/.mydocker/lib/extract-credentials.sh

echo -n "Input private branch: "
read branch
if [ -z "$branch" ]; then
    branch=master
fi
echo "private-branch:${branch}" >> $HOME/.mydocker/var/config

bash $HOME/.mydocker/lib/sync-private.sh

sudo /usr/sbin/sshd

if [ "$*" = "zsh" -o "$*" = "" ]; then
    zsh
    zsh -c "$HOME/.mydocker/bin/sync-mydocker"
    r=$?
    if [ $r != 0 ]; then
        echo "sync-mydocker failed!"
        zsh
    fi
elif [ -n "$1" -a -e $HOME/.mydocker/var/branch/startup/$1.sh ]; then
    bash $HOME/.mydocker/var/branch/startup/$1.sh
elif [ -n "$1" -a -e $HOME/.mydocker/private/startup/$1.sh ]; then
    bash $HOME/.mydocker/private/startup/$1.sh
elif [ "$#" != 0 ]; then
    "$@"
fi

