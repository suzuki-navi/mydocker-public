
bash $(dirname "$0")/download-openjdk.sh 13

export JAVA_HOME=$HOME/.mydocker/var/host/openjdk-13
export PATH=$JAVA_HOME/bin:$PATH

