#!/usr/bin/env perl

use 5.016;
use warnings;
use Math::BigInt;

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

my $fi = (1+sqrt(5))/2;
my $res;

sub little_fib {
    return ($fi**$_[0] - (1-$fi)**$_[0])/(2*$fi - 1);
}

if ($n < 70) {
    $res = little_fib($n);
} else {
    my $prev_1 = little_fib(69);
    my $prev_2 = little_fib(68);
    for (70 .. $n) {
        my $temp = Math::BigInt->new($prev_1);
        $prev_1 = Math::BigInt->new($prev_1 + $prev_2);
        $prev_2 = Math::BigInt->new($temp);
    }
    $res = Math::BigInt->new($prev_1);
}
say "Fibbonaci number is $res";