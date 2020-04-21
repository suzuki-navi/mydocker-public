
set -Ceu

scala_version=

while [ "$#" != 0 ]; do
    if [ -z "$scala_version" ]; then
        scala_version=$1
    else
        echo  "Unexpected argument" >&2
        exit 1
    fi
    shift
done

if [ -z "$scala_version" ]; then
    scala_version=2.13.1
fi

var_dir=$HOME/.mydocker/var
host_dir=$var_dir/host
tmppath=$var_dir/scala-${scala_version}-tmp
target_dir=$host_dir/scala

if [ -e $target_dir/bin/scala ]; then
    exit
fi

url="https://downloads.lightbend.com/scala/${scala_version}/scala-${scala_version}.tgz"
fname="scala-${scala_version}.tgz"
tardirname="scala-${scala_version}"

if [ -e $tmppath ]; then
    rm -rf $tmppath
fi
mkdir -p $tmppath

curl -f -L $url > $tmppath/$fname.tmp
mv $tmppath/$fname.tmp $tmppath/$fname

tar xzf $tmppath/$fname -C $tmppath

if [ -e $target_dir ]; then
    rm -rf $target_dir
fi
mkdir -p $(dirname $target_dir)
mv $tmppath/$tardirname $target_dir
rm -rf $tmppath

