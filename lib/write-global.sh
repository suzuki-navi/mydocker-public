
set -Ceu

sync_config_name=$1

if [ ! -e $HOME/.ssh ]; then
    mkdir -p $HOME/.ssh
    chmod 700 $HOME/.ssh
fi

if [ -e .ssh/known_hosts -a -e $HOME/.ssh/known_hosts ]; then
    # .ssh/known_hosts は下でカレントディレクトリから $HOME にコピーするので、
    # ここではマージしたものをいったんカレントディレクトリに書き出す
    bash $HOME/.mydocker/lib/merge-known-hosts.sh .ssh/known_hosts $HOME/.mydocker/var/known_hosts >| $HOME/.mydocker/var/known_hosts
    if ! cmp -s $HOME/.mydocker/var/known_hosts .ssh/known_hosts; then
        cp $HOME/.mydocker/var/known_hosts .ssh/known_hosts
    fi
fi

if [ -e .zsh_history ]; then
    # .zsh_history をマージしたものを $HOME に書き出す
    cp .zsh_history $HOME/.mydocker/var/.zsh_history
    diff -u .zsh_history $HOME/.zsh_history | grep -E -e '^\+' | cut -b2- >> $HOME/.mydocker/var/.zsh_history
    cp $HOME/.mydocker/var/.zsh_history $HOME/.zsh_history
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

