#!/usr/bin/env perl

use 5.016;
use warnings;

if (@ARGV < 2) {
    die "Not enough arguments";
}

my ($haystack, $needle) = @ARGV;
my $pos = index $haystack, $needle;
if ($pos < 0) {
    warn 'Not found';
    exit;
}

say $pos;
say substr $haystack, $pos;
