
set -Ceu

golang_version=1.12.6

if [ ! -e $HOME/.mydocker/var/packages/golang ]; then (
    mkdir -p $HOME/.mydocker/var/packages/golang
    cd $HOME/.mydocker/var/packages/golang

    fname="go${golang_version}.linux-amd64.tar.gz"
    curl -L "https://dl.google.com/go/$fname" | tar xzf -
); fi

