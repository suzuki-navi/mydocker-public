
set -Ceu

mkdir -p $HOME/.mydocker/credentials
chmod 700 $HOME/.mydocker/credentials

if [ ! -e $HOME/.mydocker/var/credentials.txt ]; then
    echo "Not found: $HOME/.mydocker/var/credentials.txt."
    echo "Input credential:"
    cat > $HOME/.mydocker/var/credentials.txt
fi

(
    cd $HOME/.mydocker/credentials
    cat $HOME/.mydocker/var/credentials.txt | base64 -d | openssl enc -d -aes256 -pbkdf2 >| $HOME/.mydocker/var/credentials.tar.gz
    tar xzf $HOME/.mydocker/var/credentials.tar.gz
)

(
    cd $HOME/.mydocker/credentials
    bash $HOME/.mydocker/lib/write-global.sh credential-sync
)

