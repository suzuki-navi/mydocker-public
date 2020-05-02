
set -Ceu

if [ ! -e $HOME/.ssh ]; then
    mkdir -p $HOME/.ssh
    chmod 700 $HOME/.ssh
fi

targets='.ssh .aws'
for d in $targets; do
    if [ -e $d ]; then
        for f in $(find $d -type f); do
            if [ $f != ".ssh/known_hosts" ]; then
                d=$(dirname $HOME/$f)
                if [ ! -e $d ]; then
                    mkdir -p $d;
                fi
                cp --preserve=mode,timestamp -vf $f $HOME/$f
                chmod 600 $HOME/$f
            fi
        done
    fi
done

# .gitconfig
if [ -e .global-gitconfig ]; then
    cp --preserve=mode,timestamp -vf .global-gitconfig $HOME/.gitconfig
fi

# .mydocker/.git/config
if [ -e mydocker-git/config ]; then
    cp mydocker-git/config $HOME/.mydocker/.git/config
fi

# .ssh/known_hosts
if [ -e .ssh/known_hosts ]; then
    cp .ssh/known_hosts $HOME/.ssh/known_hosts
fi

# .zsh_history
if [ -e .zsh_history ]; then
    cp .zsh_history $HOME/.zsh_history
fi

# .psql_history
if [ -e .psql_history ]; then
    cp .psql_history $HOME/.psql_history
fi

