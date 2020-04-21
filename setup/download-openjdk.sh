
set -Ceu

openjdk_version=

while [ "$#" != 0 ]; do
    if [ -z "$openjdk_version" ]; then
        openjdk_version=$1
    else
        echo  "Unexpected argument" >&2
        exit 1
    fi
    shift
done

if [ -z "$openjdk_version" ]; then
    openjdk_version=13
fi

var_dir=$HOME/.mydocker/var
host_dir=$var_dir/host
tmppath=$var_dir/openjdk-${openjdk_version}-tmp
target_dir=$host_dir/openjdk-${openjdk_version}

if [ -e $target_dir/bin/java ]; then
    exit
fi

if [ $openjdk_version = 8 ]; then
    url="https://download.java.net/openjdk/jdk8u40/ri/openjdk-8u40-b25-linux-x64-10_feb_2015.tar.gz"
    fname="openjdk-8u40-b25-linux-x64-10_feb_2015.tar.gz"
    tardirname=java-se-8u40-ri
elif [ $openjdk_version = 11 ]; then
    url="https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz"
    fname="openjdk-11.0.02_linux-x64_bin.tar.gz"
    tardirname=jdk-11.0.2
elif [ $openjdk_version = 12 ]; then
    url="https://download.java.net/java/GA/jdk12/33/GPL/openjdk-12_linux-x64_bin.tar.gz"
    fname="openjdk-12.0.0_linux-x64_bin.tar.gz"
    tardirname=jdk-12
elif [ $openjdk_version = 13 ]; then
    url="https://download.java.net/java/GA/jdk13.0.1/cec27d702aa74d5a8630c65ae61e4305/9/GPL/openjdk-13.0.1_linux-x64_bin.tar.gz"
    fname="openjdk-13.0.1_linux-x64_bin.tar.gz"
    tardirname=jdk-13.0.1
else
    echo "Unknown openjdk_version: $openjdk_version"
    exit 1
fi

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

