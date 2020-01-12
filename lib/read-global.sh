
set -Ceu

sync_config_name=$1

if [ -e .ssh/known_hosts -a -e $HOME/.ssh/known_hosts ]; then
    # .ssh/known_hosts は下で $HOME からカレントディレクトリにコピーするので、
    # ここではマージしたものをいったん $HOME に書き出す
    bash $HOME/.mydocker/lib/merge-known-hosts.sh .ssh/known_hosts $HOME/.ssh/known_hosts >| $HOME/.mydocker/var/known_hosts
    if ! cmp -s $HOME/.mydocker/var/known_hosts .ssh/known_hosts; then
        cp $HOME/.mydocker/var/known_hosts $HOME/.ssh/known_hosts
    fi
fi

if [ -e .zsh_history -a -e $HOME/.zsh_history ]; then
    # .zsh_history をマージしたものをカレントディレクトリに書き出す
    cp .zsh_history $HOME/.mydocker/var/.zsh_history
    diff -u .zsh_history $HOME/.zsh_history | grep -e '^+' | grep -v -e '^+++' | cut -b2- >> $HOME/.mydocker/var/.zsh_history
    cp $HOME/.mydocker/var/.zsh_history .zsh_history
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

