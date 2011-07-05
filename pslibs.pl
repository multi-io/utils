#!/usr/bin/perl -w
# 
# author Olaf Klischat

use strict;

sub usage() {

    print STDERR <<EOF;
usage: pslibs.pl [-f] [-n] <pid>

print libraries/devices process <pid> currently uses

If "-n" is supplied, <pid> denotes the process name instead of the pid
If "-f" is supplied, process all child processes of the specified process
as well.
EOF

}


use Getopt::Std;

my %opts;
getopts('fn', \%opts);

if ($#ARGV == -1) {
    usage(); exit -1;
}

my @ptbl;

sub initptbl {
    if (!@ptbl) {
        use Proc::ProcessTable;
        @ptbl = @{(new Proc::ProcessTable)->table};        
    }
}

sub pidof($) {
    initptbl();
    my $name = shift;
    for my $p (@ptbl) {
        if ($p->fname =~ $name) {
            return $p->pid;
        }
    }
    return 0;
}


sub getchildren($) {
    initptbl();
    my $pid = shift;
    my @directChildren = grep {$_->ppid == $pid} @ptbl;
    return ($pid, map { getchildren($_->pid) } @directChildren);
}

my $name = $ARGV[0];
my $ppid;

if ($opts{'n'}) {
    $ppid = pidof($name) || die "no such process: $name";
} else {
    $ppid = $name;
}

my @pids = ($ppid);

if ($opts{'f'}) {
    @pids = getchildren($ppid);
}

my %libs = ();   # map <libname> => 1 (libname as key for avoiding duplicates)

for my $pid (@pids) {
    open(MAPS,"</proc/$pid/maps") || die "couldn't open /proc/$pid/maps: $!";
    while(<MAPS>) {
        if (m!\s(/.*?)\s!) {
            $libs{$1} = 1;
        }
    }
    close MAPS;
}

foreach my $lib (sort keys %libs) {
    print $lib . "\n";
}
