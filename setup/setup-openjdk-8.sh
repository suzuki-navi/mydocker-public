
bash $(dirname "$0")/download-openjdk.sh 8

export JAVA_HOME=$HOME/.mydocker/var/host/openjdk-8
export PATH=$JAVA_HOME/bin:$PATH

