#!/usr/bin/env perl -s
use 5.016;
use warnings;
use vars qw($d $s $f);

$d = $d ? $d : "\t";
my %fields = $f ? map { $_ => 1 } split(',', $f) : (-1 => 1);

while (<>) {
	chomp;
	my $k = 1;
	/$d/ ? say join($d, grep {$fields{$k++} || $fields{-1}} split($d)) : !$s && say;
}