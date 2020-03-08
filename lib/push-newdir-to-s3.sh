#!/bin/bash

set -Ceu

name=$1

if [ -z "$name" ]; then
    echo "Name not specified" >&2
    exit 1
fi
if [ ! -d "$HOME/$name" ]; then
    echo "Not found: $HOME/$name" >&2
    exit 1
fi

s3_archive_bucket=$(bash $HOME/.mydocker/lib/read-config.sh s3_archive_bucket)
s3_archive_prefix=$(bash $HOME/.mydocker/lib/read-config.sh s3_archive_prefix)

s3_last_ls_line=$(aws s3 ls s3://$s3_archive_bucket/$s3_archive_prefix/$name.tar.gz. | LC_ALL=C sort | tail -n1)
if [ -n "$s3_last_ls_line" ]; then
    echo "Found: s3://$s3_archive_bucket/$s3_archive_prefix/$name.tar.gz" >&2
    exit 1
fi

next_last_num=0001

mkdir -p $HOME/.mydocker/var/archive
(
    find $HOME/$name -type f | LC_ALL=C sort | while read path; do
        echo $path
        cat $path | sha1sum | cut -b-40
    done
) >| $HOME/.mydocker/var/archive/$name.tar.gz.$next_last_num.hash.txt
cat $HOME/.mydocker/var/archive/$name.tar.gz.$next_last_num.hash | sha1sum | cut -b-40 >| $HOME/.mydocker/var/archive/$name.tar.gz.$next_last_num.hash

(
    cd $HOME
    tar cf - $name | gzip -n -c > $HOME/.mydocker/var/archive/$name.tar.gz.$next_last_num.tmp
)
mv $HOME/.mydocker/var/archive/$name.tar.gz.$next_last_num.tmp $HOME/.mydocker/var/archive/$name.tar.gz.$next_last_num

echo "push to s3://$s3_archive_bucket/$s3_archive_prefix/$name.tar.gz.$next_last_num"
aws s3 cp $HOME/.mydocker/var/archive/$name.tar.gz.$next_last_num s3://$s3_archive_bucket/$s3_archive_prefix/$name.tar.gz.$next_last_num

