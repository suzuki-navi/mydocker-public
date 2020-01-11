
set -Ceu

name=$1

value=$(cat $HOME/.mydocker/credentials/config | sed -n -E -e "/^$name:/p" | sed -e "s/^$name://")
if [ -n "$value" ]; then
    echo "$value"
    exit
fi

value=$(cat $HOME/.mydocker/private/config | sed -n -E -e "/^$name:/p" | sed -e "s/^$name://")
if [ -n "$value" ]; then
    echo "$value"
    exit
fi

exit 1

