
cat $1 $2 | perl -e '
    my @arr = ();
    while (my $line =<STDIN>) {
        unless (grep {$_ eq $line} @arr) {
            print $line;
            push(@arr, $line);
        }
    }
'

