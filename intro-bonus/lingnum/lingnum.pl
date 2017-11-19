#!/usr/bin/env perl

use 5.016;
use warnings;

if (@ARGV < 1) {
    die "Not enough arguments";
} elsif (@ARGV > 1) {
    die "Too many arguments";
};

sub isint {
    return int($_[0]) - $_[0] ? 0 : 1;
};

my ($n) = @ARGV;
unless (isint($n) and $n > 0 and $n <= 1000000000) {
    die "Wrong argument";
};

sub get_digit {
    return $_[0] % 10;
};

my %digitMap = (
    0 => '',
    1 => 'один',
    2 => 'два',
    3 => 'три',
    4 => 'четыре',
    5 => 'пять',
    6 => 'шесть',
    7 => 'семь',
    8 => 'восемь',
    9 => 'девять',
    10 => 'десять',
);

my %rankMap = (
    1 => ['', '', ''],
    1000 => ['тысяча', 'тысячи', 'тысяч'],
    1000000 => ['миллион', 'миллиона', 'миллионов'],
    1000000000 => ['миллиард',],
);

sub make_hundred {
    my $val = $_[0];
    if (!$val) {
        return '';
    } elsif ($val == 1) {
        return 'сто';
    } elsif ($val == 2) {
        return 'двести'
    } elsif ($val < 5) {
        return $digitMap{$val} . 'ста';
    }
    return $digitMap{$val} . 'сот';
};

sub make_tenth {
    my $val = $_[0];
    if ($val < 2) {
        return 'use_teens';
    } elsif ($val < 4) {
        return $digitMap{$val} . 'дцать';
    } elsif ($val == 4) {
        return 'сорок';
    } elsif ($val == 9) {
        return 'девяноста'
    }
    return $digitMap{$val} . 'десят';
};

sub make_teens {
    my $val = $_[0];
    if ($val == 2) {
        return 'двенадцать';
    } elsif ($val == 3) {
        return $digitMap{$val} . 'надцать';
    }
    return substr ($digitMap{$val}, 0, -2) . 'надцать';
};

my ($remains, $delim) = ($n, 1000000000);
my @final_result;
while ($remains) {
    if (int($remains / $delim)) {
        my $part = int($remains / $delim);
        my $hundred_part = make_hundred(int($part / 100));
        my $tenth_part = '';
        my $digit_part = '';
        if ($part % 100 >= 20) {
            $tenth_part = make_tenth(int($part % 100 / 10));
            $digit_part = $digitMap{$part % 10};
        } elsif ($part % 100 > 0 and $part % 100 <= 10) {
            $digit_part = $digitMap{$part % 10 ? $part % 10 : 10};
        } elsif ($part % 100 > 0) {
            $tenth_part = make_teens($part % 10);
        };

        if ($delim == 1000) {
            $digit_part eq 'один' ? $digit_part = 'одна' : 0;
            $digit_part eq 'два' ? $digit_part = 'две' : 0  ;
        };

        my $create_full_part = sub {
            for my $el (@_) {
                if ($el) {
                    push @final_result, $el;
                }
            };
        };

        if ($part % 10 == 1 and $digit_part) {
            $create_full_part->($hundred_part, $tenth_part, $digit_part, @{$rankMap{$delim}}[0]);
        } elsif (($part % 10 > 0) and ($part % 10 <= 4) and $digit_part) {
            $create_full_part->($hundred_part, $tenth_part, $digit_part, @{$rankMap{$delim}}[1]);
        } else {
            $create_full_part->($hundred_part, $tenth_part, $digit_part, @{$rankMap{$delim}}[2]);
        }
    }
    $remains %= $delim;
    $delim /= 1000;
};

say join(' ', @final_result);

