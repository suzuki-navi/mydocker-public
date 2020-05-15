
bash $(dirname "$0")/download-scala.sh

if ! type java >/dev/null 2>&1; then
    . $HOME/.mydocker/setup/setup-openjdk-13.sh
fi

export SCALA_HOME=$HOME/.mydocker/var/host/scala
export PATH=$SCALA_HOME/bin:$PATH

