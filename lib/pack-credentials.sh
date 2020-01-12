
set -Ceu

(
    find $HOME/.mydocker/credentials -type f | LC_ALL=C sort | while read path; do
        echo $path
        cat $path
    done
) > $HOME/.mydocker/var/credentnials.raw.txt.1

if ! cmp -s $HOME/.mydocker/var/credentnials.raw.txt $HOME/.mydocker/var/credentnials.raw.txt.1; then (
    diff -u $HOME/.mydocker/var/credentnials.raw.txt $HOME/.mydocker/var/credentnials.raw.txt.1

    cd $HOME/.mydocker/credentials

    tar czf $HOME/.mydocker/var/credentials.tar.gz.1 .
    cat $HOME/.mydocker/var/credentials.tar.gz | openssl enc -e -aes256 -pbkdf2 | base64 | tr -d '\n' >| $HOME/.mydocker/var/credentials.txt
    echo >> $HOME/.mydocker/var/credentials.txt
    cat $HOME/.mydocker/var/credentials.txt
    cp $HOME/.mydocker/var/credentnials.raw.txt.1 $HOME/.mydocker/var/credentnials.raw.txt
) else
    echo "Credentials no changes"
fi

