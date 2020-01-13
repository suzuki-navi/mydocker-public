
set -Ceu

####################################################################################################

repos=$(bash $HOME/.mydocker/lib/read-config.sh private-repos)

if [ -z "$repos" ]; then
    echo "Illegal ~/.mydocker/credentials/config" >&2
    exit 1
fi

mkdir -p $HOME/.mydocker/private

if [ -e $HOME/.mydocker/private/.git ]; then (
    cd $HOME/.mydocker/private

    bash $HOME/.mydocker/lib/read-global.sh private-sync
); else (
    cd $HOME/.mydocker/private

    # 最初にgit cloneするときのためだけのknown_hostsを準備
    flag_copy_known_hosts=
    if [ ! -e $HOME/.ssh/known_hosts -a /md/etc/known_hosts ]; then
        cp /md/etc/known_hosts $HOME/.ssh/known_hosts
        flag_copy_known_hosts=1
    fi

    git clone $repos .

    # 最初にgit cloneするときのためだけのknown_hostsをフィードバック
    if [ -n "$flag_copy_known_hosts" ]; then
        bash $HOME/.mydocker/lib/merge-known-hosts.sh $HOME/.ssh/known_hosts /md/etc/known_hosts >| $HOME/.mydocker/var/known_hosts
        cp $HOME/.mydocker/var/known_hosts /md/etc/known_hosts
        rm $HOME/.ssh/known_hosts
    fi
); fi

(
    cd $HOME/.mydocker/private
    bash $HOME/.mydocker/lib/write-global.sh private-sync
)

####################################################################################################

repos=$(bash $HOME/.mydocker/lib/read-config.sh private2-repos)
branch=$(bash $HOME/.mydocker/lib/read-config.sh private2-branch)

if [ -z "$repos" ]; then
    exit
fi
if [ -z "$branch" ]; then
    branch=master
fi

mkdir -p $HOME/.mydocker/private2

if [ -e $HOME/.mydocker/private2/.git ]; then (
    cd $HOME/.mydocker/private2

    bash $HOME/.mydocker/lib/read-global.sh private2-sync

    bash $HOME/.mydocker/lib/autocommit.sh
); else (
    cd $HOME/.mydocker/private2

    git clone $repos .
    git checkout $branch

); fi

(
    cd $HOME/.mydocker/private2
    bash $HOME/.mydocker/lib/write-global.sh private2-sync
)

####################################################################################################

