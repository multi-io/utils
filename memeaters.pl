#! /usr/bin/perl -w

open (PS, "ps laxw |");

map { printf " %7s %7s %7s   %s\n", $_->[2], $_->[6], $_->[7], join(' ',@$_[12 .. $#$_]); }
  grep { $_->[6] =~ "VSZ|[0-9]{5,}" }
    map { [ split ] } <PS>;
