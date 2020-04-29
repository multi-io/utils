#! /usr/bin/perl -w

open (PS, "ps laxw |");
print grep { (split(/\s+/,$_))[6] =~ "[0-9]{5,}" } <PS>;
