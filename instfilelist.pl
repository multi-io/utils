#!/usr/bin/perl -w
# in: 'make install' output on stdin
# out: list of installed files on stdout

# beware: heuristic, unreliable

my %files = ();

while (<>) {

    if (m!^\s*(?:(?:/bin/sh\s+)?[^\s]*libtool.*?--mode=install\s+)?(?:/usr/bin/)?install\s.*?\s(/.*?)\s*$!) {
#    if (m!^\s*(?:/usr/bin/)?install.*?\s(/.*?)\s*$! || 
#        m!libtool.*?--mode=install.*?\s(/[^\s]*?)\s*$!) {

        $files{$1} = 1;
    }
}

foreach my $file (sort keys %files) {
    print $file . "\n";
}


