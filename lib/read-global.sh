
set -Ceu

sync_config_name=$1

if [ -e .ssh/known_hosts -a -e $HOME/.ssh/known_hosts ]; then
    bash $HOME/.mydocker/lib/merge-known-hosts.sh .ssh/known_hosts $HOME/.ssh/known_hosts >| $HOME/.mydocker/var/known_hosts
    if ! diff $HOME/.mydocker/var/known_hosts .ssh/known_hosts >/dev/null; then
        cp $HOME/.mydocker/var/known_hosts $HOME/.ssh/known_hosts
    fi
fi

targets='.ssh .aws'
for f in $(find $targets -type f); do
    if [ -e $HOME/$f ]; then
        cp --preserve=mode,timestamp -vf $HOME/$f $f
    fi
done

if [ -e .global-gitconfig -a -e $HOME/.gitconfig ]; then
    cp --preserve=mode,timestamp -vf $HOME/.gitconfig .global-gitconfig
fi

