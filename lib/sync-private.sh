
set -Ceu

####################################################################################################

repos=$(bash $HOME/.mydocker/lib/read-config.sh private-repos)
branch=$(bash $HOME/.mydocker/lib/read-config.sh private-branch)

if [ -z "$repos" ]; then
    echo "Illegal ~/.mydocker/credentials/config" >&2
    exit 1
fi

mkdir -p $HOME/.mydocker/private

if [ -e $HOME/.mydocker/private/.git ]; then (
    cd $HOME/.mydocker/private

    bash $HOME/.mydocker/lib/read-global.sh
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

    # 最初にgit cloneするときに自動生成される .gitconfig を削除
    rm $HOME/.gitconfig

    if [ -e $HOME/.mydocker/private/branch-$branch ]; then
        ln -sv $HOME/.mydocker/private/branch-$branch $HOME/.mydocker/var/branch
    else
        echo "Not found: $HOME/.mydocker/private/branch-$branch"
    fi
); fi

(
    cd $HOME/.mydocker/private
    bash $HOME/.mydocker/lib/write-global.sh
)

####################################################################################################

if [ -e $HOME/.mydocker/private/branch-$branch ]; then (
    cd $HOME/.mydocker/private/branch-$branch

    bash $HOME/.mydocker/lib/read-global.sh

    bash $HOME/.mydocker/lib/autocommit.sh

    bash $HOME/.mydocker/lib/write-global.sh
); fi

####################################################################################################

