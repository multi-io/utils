#!/usr/bin/perl -w
# 
# author Olaf Klischat

use strict;
use Getopt::Long;

my $cvscmd = "cvs";
my $quiet = 0;

exit(1) unless GetOptions ("cvs=s"  => \$cvscmd,
                           "quiet|q" => \$quiet);

sub infoMsg {
    ! $quiet and print STDERR "cvsshowunkn.pl: @_\n";
}


infoMsg("running $cvscmd status...");

open(CVSSTATUS,"$cvscmd status 2>&1 |") or die "$!";

my @knownFiles;
my $currDir;
while (<CVSSTATUS>) {
    if (/^cvs .*: Examining (.*)/) {
	$currDir = "${1}";
	$currDir ne "." and $currDir = "./$currDir";
    }
    elsif (/^File: (\S+).+Status:/) {   # TODO: file names containing whitespaces won't be recognized this way
	push @knownFiles, "${currDir}/$1";
    }
}


infoMsg("finding unknown files...");

use File::Find;

find(\&findCallback, '.');

sub findCallback {
    -f && $File::Find::name !~ /\/CVS\// && ! ( grep {$_ eq $File::Find::name} @knownFiles ) && print "$File::Find::name\n";
}
