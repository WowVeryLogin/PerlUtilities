#!/usr/bin/env perl

use 5.016;
use warnings;

if (@ARGV < 1) {
    die "Not enough arguments";
} elsif (@ARGV > 1) {
    die "Too many arguments";
}

sub isint {
    return int($_[0]) - $_[0] ? 0 : 1;
}

my ($n) = @ARGV;
if (not(isint($n) and $n > 0)) {
    die "Wrong argument";
}

my $res = 1;
for my $i (2..$n) {
    $res *= $i;
}
say "Factorial is $res";

