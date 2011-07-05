#!/usr/bin/perl -w

use Getopt::Std;
use vars qw/$opt_t $opt_h/;

getopts('ht:');

if ($opt_h) {
    print "usage: slowdown.pl [-t <ms>]\n";
    print " pipe stdin to stdout, sleeping <ms> (default 4) milliseconds between lines.\n";
    exit;
}

#$delay = ( $opt_t || 40 ) / 1000;  # sehr cool, aber versagt, wenn $opt == 0 ...

$delay = ( defined($opt_t)?$opt_t:40 ) / 1000;

use IO::Handle;

STDOUT->autoflush(1);

while (<STDIN>) {
    select(undef, undef, undef, $delay);  # lt. Doku die einzige einfache(?) Moeglichkeit, kurze Zeitspannen zu sleepen
    print $_;
}
