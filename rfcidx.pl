#!/usr/bin/perl -w

use Getopt::Std;

my %opts;

getopts('s',\%opts);

my @fileNames = $opts{'s'}? sort @ARGV : @ARGV;

FILE: for my $fn (@fileNames) {
    open(F,"<$fn") or { print STDERR "couldn't read $f: $!"; next FILE; };

    # TODO: sybolic names QU: how to do it best (no strings and such)?
    my $state = 1;
    while(1) {
        my $line = <F> or { print STDERR "parse error in $f"; close F; next FILE; };
      SW: {
            if ($state == 1) {
                if ($line !~ /^\s*$/) { $state = 2; last SW; }
                last SW;
            }
            if ($state == 2) {
                if ($line =~ /^\s*$/) { $state = 3; last SW; }
                last SW;
            }
            if ($state == 3) {
                if ($line =~ /^\s*(\S+)\s*$/) { printf "%-12s  %s\n", "${fn}:", $1; close F; next FILE; }
                last SW;
            }
        }
    }
}
