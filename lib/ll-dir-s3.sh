#!/bin/bash

set -Ceu

s3_archive_bucket=$(bash $HOME/.mydocker/lib/read-config.sh s3_archive_bucket)
s3_archive_prefix=$(bash $HOME/.mydocker/lib/read-config.sh s3_archive_prefix)

echo s3://$s3_archive_bucket/$s3_archive_prefix/
aws s3 ls s3://$s3_archive_bucket/$s3_archive_prefix/

