#!/usr/bin/perl -w

open(CDDB, "<" . shift @ARGV);


my @titles = map { /TTITLE\d+=(.*)/ } (grep /^TTITLE\d/, <CDDB>);

for my $title (@titles) {
    my $wavfile = shift @ARGV or die "unmatched number of titles in cddb file and .wav files on cmd line (too few wav files)";
    $title =~ s/[ ,'"\.]/_/g;
    if (my ($num) = +($wavfile =~ /(\d+)\.wav$/)) {
        $title = "$num-$title";
    }

    print "renaming $wavfile to $title.wav\n";
    rename $wavfile, "$title.wav";
    if (my $base = ($wavfile=~/(.*).wav$/)[0]) {
        rename "$base.mp3", "$title.mp3";
        rename "$base.ogg", "$title.ogg";
    }
}

if (@ARGV) {
    die "unmatched number of titles in cddb file and .wav files on cmd line (too many wav files)"
}
