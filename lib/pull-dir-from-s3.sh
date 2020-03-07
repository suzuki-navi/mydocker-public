#!/bin/bash

set -Ceu

name=$1

if [ -z "$name" ]; then
    echo "Name not specified" >&2
    exit 1
fi
if [ -e "$HOME/$name" ]; then
    echo "Found: $HOME/$name" >&2
    exit 1
fi

s3_archive_bucket=$(bash $HOME/.mydocker/lib/read-config.sh s3_archive_bucket)
s3_archive_prefix=$(bash $HOME/.mydocker/lib/read-config.sh s3_archive_prefix)

s3_last_ls_line=$(aws s3 ls s3://$s3_archive_bucket/$s3_archive_prefix/$name.tar.gz. | LC_ALL=C sort | tail -n1)
if [ -z "$s3_last_ls_line" ]; then
    echo "Not found: s3://$s3_archive_bucket/$s3_archive_prefix/$name.tar.gz" >&2
    exit 1
fi
s3_last_fname=$(echo "$s3_last_ls_line" | awk '{print $4}')
s3_last_num=$(echo "$s3_last_fname" | sed -E -e 's/^.+\.tar\.gz\.([0-9]+)$/\1/')
if [ -z "$s3_last_num" ]; then
    echo "Not found: s3://$s3_archive_bucket/$s3_archive_prefix/$name.tar.gz" >&2
    exit 1
fi

mkdir -p $HOME/.mydocker/var/archive
echo "pull from s3://$s3_archive_bucket/$s3_archive_prefix/$name.tar.gz.$s3_last_num"
aws s3 cp s3://$s3_archive_bucket/$s3_archive_prefix/$name.tar.gz.$s3_last_num $HOME/.mydocker/var/archive/$name.tar.gz.$s3_last_num

(
    cd $HOME
    tar xzf $HOME/.mydocker/var/archive/$name.tar.gz.$s3_last_num
)

(
    find $HOME/$name -type f | LC_ALL=C sort | while read path; do
        echo $path
        cat $path | sha1sum | cut -b-40
    done
) > $HOME/.mydocker/var/archive/$name.tar.gz.$s3_last_num.hash.txt
cat $HOME/.mydocker/var/archive/$name.tar.gz.$s3_last_num.hash.txt | sha1sum | cut -b-40 > $HOME/.mydocker/var/archive/$name.tar.gz.$s3_last_num.hash

