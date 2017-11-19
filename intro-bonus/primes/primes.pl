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

my (@known_primes, @lowest_delimeter);

print "1 ";

for my $i (2 .. $n) {
    unless ($lowest_delimeter[$i]) { 
        $lowest_delimeter[$i] = $i;
        push(@known_primes, $i);
    };
    for my $prime (@known_primes) {
        if ($prime * $i > $n or $prime > $lowest_delimeter[$i]) {
            last;
        }
        $lowest_delimeter[$prime * $i] = $prime;
    };
};

print "@known_primes \n";