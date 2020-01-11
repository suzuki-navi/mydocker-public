
set -Ceu

sync_config_name=$1

if [ ! -e $HOME/.ssh ]; then
    mkdir -p $HOME/.ssh
    chmod 700 $HOME/.ssh
fi

if [ -e .ssh/known_hosts -a -e $HOME/.ssh/known_hosts ]; then
    bash $HOME/.mydocker/lib/merge-known-hosts.sh .ssh/known_hosts $HOME/.mydocker/var/known_hosts >| $HOME/.mydocker/var/known_hosts
    if ! diff $HOME/.mydocker/var/known_hosts .ssh/known_hosts >/dev/null; then
        cp $HOME/.mydocker/var/known_hosts .ssh/known_hosts
    fi
fi

targets='.ssh .aws'
for f in $(find $targets -type f); do
    d=$(dirname $HOME/$f)
    if [ ! -e $d ]; then
        mkdir -p $d;
    fi
    cp --preserve=mode,timestamp -vf $f $HOME/$f
done

if [ -e .global-gitconfig ]; then
    cp --preserve=mode,timestamp -vf .global-gitconfig $HOME/.gitconfig
fi

