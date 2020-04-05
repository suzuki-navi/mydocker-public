
set -Ceu

cat $1
diff -u $1 $2 | grep -a -e '^+' | grep -a -v -e '^+++' | cut -b2-

