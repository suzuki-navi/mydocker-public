
set -Ceu

targets='.ssh .aws'
for d in $targets; do
    if [ -e $d ]; then
        for f in $(find $d -type f); do
            if [ $f != ".ssh/known_hosts" ]; then
               if [ -e $HOME/$f ]; then
                   cp --preserve=mode,timestamp -vf $HOME/$f $f
               fi
            fi
        done
    fi
done

# .gitconfig
if [ -e .global-gitconfig -a -e $HOME/.gitconfig ]; then
    cp --preserve=mode,timestamp -vf $HOME/.gitconfig .global-gitconfig
fi

# .git/config
if [ -e mydocker-git/config ]; then
    cp --preserve=mode,timestamp -vf $HOME/.mydocker/.git/config mydocker-git/config
fi

# .tmux.conf
if [ -e .tmux.conf ]; then
    cp --preserve=mode,timestamp -vf $HOME/.tmux.conf .tmux.conf
fi

if [ -e .git ]; then
    bash $HOME/.mydocker/lib/autocommit.sh
fi

history_flag=

# .ssh/known_hosts
if [ -e .ssh/known_hosts -a -e $HOME/.ssh/known_hosts ]; then
    bash $HOME/.mydocker/lib/merge-known-hosts.sh .ssh/known_hosts $HOME/.ssh/known_hosts >| $HOME/.mydocker/var/known_hosts
    if ! cmp -s $HOME/.mydocker/var/known_hosts .ssh/known_hosts; then
        cp $HOME/.mydocker/var/known_hosts .ssh/known_hosts
        history_flag=1
    fi
fi

# .zsh_history
if [ -e .zsh_history -a -e $HOME/.zsh_history ]; then
    bash $HOME/.mydocker/lib/merge-history.sh .zsh_history $HOME/.zsh_history >| $HOME/.mydocker/var/.zsh_history
    if ! cmp -s $HOME/.mydocker/var/.zsh_history .zsh_history; then
        cp $HOME/.mydocker/var/.zsh_history .zsh_history
        history_flag=1
    fi
fi

# .psql_history
if [ -e .psql_history -a -e $HOME/.psql_history ]; then
    bash $HOME/.mydocker/lib/merge-history.sh .psql_history $HOME/.psql_history >| $HOME/.mydocker/var/.psql_history
    if ! cmp -s $HOME/.mydocker/var/.psql_history .psql_history; then
        cp $HOME/.mydocker/var/.psql_history .psql_history
        history_flag=1
    fi
fi

if [ -e .git ]; then
    if [ -n "$history_flag" ]; then
        bash $HOME/.mydocker/lib/autocommit.sh
    fi
fi

