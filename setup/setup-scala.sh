
bash $(dirname "$0")/download-scala.sh

export SCALA_HOME=$HOME/.mydocker/var/host/scala
export PATH=$SCALA_HOME/bin:$PATH

