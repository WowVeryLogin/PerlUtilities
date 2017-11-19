#!/usr/bin/env perl

use 5.016;
use warnings;
use Math::Complex;

if (@ARGV < 1) {
    die "Not enough arguments";
} elsif (@ARGV > 3) {
    die "Too many arguments";
}

if (@ARGV == 1) {
    say 'Roots are x0 = x1 = 0';
    exit;
}

if (@ARGV == 2) {
    my ($a,$b) = @ARGV;
    my $root = sqrt(cplx(-$b/$a));
    if (!Re($root)) {
        $root->display_format('format' => '%.2f');
        say "Roots are x0 = x1 = $root";
    } else {
        printf "Roots are x0 = x1 = %.2f\n", $root;
    }
    exit;
}

my ($a,$b,$c) = @ARGV;
my $d = $b*$b - 4*$a*$c;
if ($d < 0) {
    my ($root0, $root1) = ((-$b-sqrt(cplx($d)))/(2*$a), (-$b+sqrt(cplx($d)))/(2*$a));
    $root0->display_format('format' => '%.2f');
    $root1->display_format('format' => '%.2f');
    say "Roots are x0 = $root0 and x1 = $root1";
    exit;
}

if ($d == 0) {
    my $root = -$b/(2*$a);
    printf "Roots are x0 = x1 = %.2f\n", $root;
    exit;
}

if ($d > 0) {
    my ($root0, $root1) = ((-$b-sqrt($d))/(2*$a), (-$b+sqrt($d))/(2*$a));
    printf "Roots are x0 = %.2f and x1 = %.2f\n", $root0, $root1;
    exit;
}