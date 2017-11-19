#!/usr/bin/env perl

use 5.016;
use warnings;

if (@ARGV < 3) {
    die "Bad arguments";
}

my ($a,$b,$c) = @ARGV;

if ($a == 0) {
    die "Not a quadratic equation";
}

my $discriminant = $b*$b - 4*$a*$c;
if ($discriminant < 0) {
    say "No real roots for this equation";
} elsif ($discriminant == 0) {
    my $root = -$b/(2*$a);
    printf "Roots are x0 = x1 = %.2f\n", $root;
} else {
    my ($root0, $root1) = ((-$b - sqrt($discriminant))/(2*$a), (-$b + sqrt($discriminant))/(2*$a));
    printf "Roots are x0 = %.2f\n and x1 = %.2f\n", $root0, $root1;
}