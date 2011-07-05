#!/usr/bin/perl -w

# The lirc (http://www.lirc.org/) kernel module and lircd daemon are
# nice and sane, irexec/liblircclient are an inflexible mess of
# interdependent internal states interacting in numerous
# half-undocumented, fully-unconfigurable ways. This is a
# replacement...

use strict;
use warnings;

use Proc::ProcessTable;


{
    my $procs = undef;
    my $lasttime = -1;

    sub getProcs() {
        my $t = Time::HiRes::time();
        unless ($t-$lasttime <= 2 and defined($procs)) {
            $procs = [ map {$_->cmndline} @{(new Proc::ProcessTable)->table} ];
            $lasttime = Time::HiRes::time();
        }
        $procs;
    }
}


sub isRunning($) {
    my $proc = shift;
    grep {$_ eq $proc} @{getProcs()};
}

$SIG{CHLD} = 'IGNORE';

sub spawn(@) {
    my $pid=fork();
    if (0==$pid) {
        exec @_ or die "couldn't exec " . join(' ',@_) . ": $!";
    }
    $pid;
}

sub spawnUnlessRunning($@) {
    my ($test,@proc) = @_;
    spawn @proc unless isRunning($test);
}

my $modes = {
 'xmms' => { START=>sub{ spawnUnlessRunning "xmms", "xmms.sh" } },
 'xawtv' => { START=>sub{
                  system "audioreset";
                  spawnUnlessRunning "xawtv", "xawtv";
                  sleep 5;
                  system "xawtv-remote fullscreen";
                  sleep 1;
              },
              STOP=>sub{ system "xawtv-remote quit"; } },
 'mplayer' => {  },
 'sleeper' => { START=>sub{
                    our ($sleeper_pid);
                    print STDERR "starting sleeper\n";
                    $sleeper_pid = spawn("sleepingsongs");
                },
                STOP=>sub{
                    our ($sleeper_pid);
                    kill 'SIGTERM', $sleeper_pid if (defined($sleeper_pid));
                } }
};


my $mode = '';

sub setMode($) {
    my $newmode = shift;
    return if $newmode eq $mode;
    &{$modes->{$mode}->{STOP}}  if defined($modes->{$mode}->{STOP});
    &{$modes->{$newmode}->{START}}  if defined($modes->{$newmode}->{START});
    $mode = $newmode;
    print STDERR "new mode: $mode\n";
}


my $actions =
{
 'xmms' => {'CH+' => sub {system "xmms.sh --fwd"},
            'CH-' => sub {system "xmms.sh --rew"},
            '5' => sub {system "xmms.sh --stop"},
            '6' => sub {print STDERR "play!\n"; system "xmms.sh --play-pause"}
           },

 'xawtv' => {'CH+' => sub {system "xawtv-remote setstation next"},
             'CH-' => sub {system "xawtv-remote setstation prev"},
             'FULL_SCREEN' => sub {system "xawtv-remote fullscreen"},
             'TV' => sub { setMode("sleeper"); },
             map { my $key=$_; ("$key" => sub {system (sprintf "xawtv-remote setstation %02u", $key-1)}) } (1..9)
            },

 'mplayer' => {'CH+' => sub {system "mplayerctl fwd"},
               'CH-' => sub {system "mplayerctl rew"},
               'FULL_SCREEN' => sub {system "mplayerctl fullscreen"},
               '6' => sub {system "mplayerctl playpause"},
               '9' => sub {system "mplayerctl subsvisibility"}
              },

 'sleeper' => {'TV' => sub { setMode("xawtv"); } },

 'default' => {'RADIO' => sub { setMode "xmms"; },
               'TV' => sub { setMode "xawtv"; },
               'MUTE' => sub { setMode "mplayer"; },
               '0' => sub { system "killall mplayer"; },
#               'VOL+' => sub {system "echo '+' | aumix" },
#               'VOL-' => sub {system "echo '-' | aumix" },
              }

};




### main loop -- receive and process keys

# receive keys in a separate sub-process so we can keep track
#   of the exact time each keypress happened regardless of the
#   time some running action takes to complete. This is to ensure
#   we don't process a keypress multiple times if the key was held
#   down just a bit longer.
use IO::Handle;

pipe KEYS_IN, KEYS_OUT;
KEYS_OUT->autoflush(1);
if (0==fork()) {
    # child
    close KEYS_IN;

    use Socket;
    use Time::HiRes;
    socket(LIRCD, PF_UNIX, SOCK_STREAM, PF_UNSPEC);
    connect(LIRCD, sockaddr_un('/dev/lircd')) or die "couldn't connect() to /dev/lircd: $!";
    while(<LIRCD>) {
        my ($key) = /.+? .+? (.*?) /;
        my $time = Time::HiRes::time();
        print KEYS_OUT "${key}\t${time}\n";
    }
    exit 0;
}
else {
    # parent
    close KEYS_OUT;
}



my $lasttime = -1;
while(<KEYS_IN>) {
    my ($key,$time) = /^(.*?)\t(.*)/;

    next if ($time - $lasttime < 0.3);   # avoid accidentally pressing a key multiple times
    $lasttime = $time;

    my $action = $actions->{$mode}->{$key} || $actions->{'default'}->{$key};
    &$action if $action;
}
