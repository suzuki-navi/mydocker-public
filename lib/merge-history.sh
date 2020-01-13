
set -Ceu

cat $1
diff -u $1 $2 | grep -e '^+' | grep -v -e '^+++' | cut -b2-

