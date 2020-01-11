
set -Ceu

(
    cd $HOME/.mydocker/credentials
    tar czf $HOME/.mydocker/var/credentials.tar.gz.1 .
    if [ ! -e $HOME/.mydocker/var/credentials.tar.gz ] || ! diff $HOME/.mydocker/var/credentials.tar.gz $HOME/.mydocker/var/credentials.tar.gz.1 >/dev/null; then
        cat $HOME/.mydocker/var/credentials.tar.gz | openssl enc -e -aes256 -pbkdf2 | base64 | tr -d '\n' >| $HOME/.mydocker/var/credentials.txt
        echo >> $HOME/.mydocker/var/credentials.txt
        cat $HOME/.mydocker/var/credentials.txt
    else
        echo "Credentials no changes"
    fi
)

