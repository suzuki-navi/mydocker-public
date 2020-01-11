
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
); else (
    cd $HOME/.mydocker/private

    git clone $repos .
); fi

(
    cd $HOME/.mydocker/private
    bash $HOME/.mydocker/lib/write-global.sh private-sync
)

