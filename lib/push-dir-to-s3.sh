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
if [ -z "$s3_last_ls_line" ]; then
    echo "Not found: s3://$s3_archive_bucket/$s3_archive_prefix/$name.tar.gz" >&2
    bash $HOME/.mydocker/lib/push-newdir-to-s3.sh $name
    exit $?
fi
s3_last_fname=$(echo "$s3_last_ls_line" | awk '{print $4}')
s3_last_num=$(echo "$s3_last_fname" | sed -E -e 's/^.+\.tar\.gz\.([0-9]+)$/\1/')
if [ -z "$s3_last_num" ]; then
    echo "Not found: s3://$s3_archive_bucket/$s3_archive_prefix/$name.tar.gz" >&2
    exit 1
fi

if [ ! -e $HOME/.mydocker/var/archive/$name.tar.gz.$s3_last_num ]; then
    echo "Perhaps conflicted" >&2
    exit 1
fi

next_last_num=$(printf "%04d" $(expr $s3_last_num + 1))

(
    find $HOME/$name -type f | LC_ALL=C sort | while read path; do
        echo $path
        cat $path | sha1sum | cut -b-40
    done
) >| $HOME/.mydocker/var/archive/$name.tar.gz.$next_last_num.hash.txt
cat $HOME/.mydocker/var/archive/$name.tar.gz.$next_last_num.hash.txt | sha1sum | cut -b-40 >| $HOME/.mydocker/var/archive/$name.tar.gz.$next_last_num.hash

if cmp -s $HOME/.mydocker/var/archive/$name.tar.gz.$s3_last_num.hash $HOME/.mydocker/var/archive/$name.tar.gz.$next_last_num.hash; then
   echo "No changes"
   exit 0
fi

(
    cd $HOME
    tar cf - $name | gzip -n -c > $HOME/.mydocker/var/archive/$name.tar.gz.$next_last_num.tmp
)
mv $HOME/.mydocker/var/archive/$name.tar.gz.$next_last_num.tmp $HOME/.mydocker/var/archive/$name.tar.gz.$next_last_num

echo "push to s3://$s3_archive_bucket/$s3_archive_prefix/$name.tar.gz.$next_last_num"
aws s3 cp $HOME/.mydocker/var/archive/$name.tar.gz.$next_last_num s3://$s3_archive_bucket/$s3_archive_prefix/$name.tar.gz.$next_last_num

