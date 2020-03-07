
set -Ceu

name=$1

if [ -e $HOME/.mydocker/var/config ]; then
    value=$(cat $HOME/.mydocker/var/config | sed -n -E -e "/^$name:/p" | sed -e "s/^$name://")
    if [ -n "$value" ]; then
        echo "$value"
        exit
    fi
fi

if [ -e $HOME/.mydocker/credentials/config ]; then
    value=$(cat $HOME/.mydocker/credentials/config | sed -n -E -e "/^$name:/p" | sed -e "s/^$name://")
    if [ -n "$value" ]; then
        echo "$value"
        exit
    fi
fi

if [ -e $HOME/.mydocker/private/config ]; then
    value=$(cat $HOME/.mydocker/private/config | sed -n -E -e "/^$name:/p" | sed -e "s/^$name://")
    if [ -n "$value" ]; then
        echo "$value"
        exit
    fi
fi

echo ""
exit

