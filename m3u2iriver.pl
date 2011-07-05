#!/usr/bin/perl -w

while (<STDIN>) {
    chomp;
    s!/!\\!g;
    print "$_\x{d}\x{a}";
}
