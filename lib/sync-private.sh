
set -Ceu

repos=$(bash $HOME/.mydocker/lib/read-config.sh repos)

if [ -z "$repos" ]; then
    echo "Illegal ~/.mydocker/credentials/config" >&2
    exit 1
fi

mkdir -p $HOME/.mydocker/private

if [ -e $HOME/.mydocker/private/.git ]; then (
    cd $HOME/.mydocker/private

    bash $HOME/.mydocker/lib/read-global.sh private-sync

    bash $HOME/.mydocker/lib/autocommit.sh

    if [ -e .zsh_history -a -e $HOME/.zsh_history ]; then
        # .zsh_history をマージ
        cp .zsh_history $HOME/.mydocker/var/.zsh_history
        diff -u .zsh_history $HOME/.zsh_history | grep -e '^+' | grep -v -e '^+++' | cut -b2- >> $HOME/.mydocker/var/.zsh_history
        cp $HOME/.mydocker/var/.zsh_history .zsh_history
        cp $HOME/.mydocker/var/.zsh_history $HOME/.zsh_history

        bash $HOME/.mydocker/lib/autocommit.sh
    fi
); else (
    cd $HOME/.mydocker/private

    if [ ! -e $HOME/.ssh/known_hosts -a /md/etc/known_hosts ]; then
        cp /md/etc/known_hosts $HOME/.ssh/known_hosts
    fi

    git clone $repos .

    if [ -e $HOME/.ssh/known_hosts -a /md/etc/known_hosts ]; then
        bash $HOME/.mydocker/lib/merge-known-hosts.sh $HOME/.ssh/known_hosts /md/etc/known_hosts >| $HOME/.mydocker/var/known_hosts
        cp $HOME/.mydocker/var/known_hosts /md/etc/known_hosts
    fi

    if [ -e .zsh_history ]; then
        cp .zsh_history $HOME/.zsh_history
    fi
); fi

(
    cd $HOME/.mydocker/private
    bash $HOME/.mydocker/lib/write-global.sh private-sync
)

