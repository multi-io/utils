#!/usr/bin/perl -w -pi --

chomp;
s!/!\\!g;
s!$!\x{d}\x{a}!;
