#!/usr/bin/env perl

use 5.016;
use warnings;
use Getopt::Long;
use IO::Handle;

my ($key,
    $numeric_sort,
    $reverse,
    $unique,
    $ignore_trailing_blanks,
    $check,
    $month_sort,
    $human_numeric_sort) = (0)x8;
GetOptions ("key|k=i" => \$key,
    "numeric-sort|n" => \$numeric_sort,
    "reverse|r" => \$reverse,
    "unique|u" => \$unique,
    "month-sort|M" => \$month_sort,
    "ignore-trailing-blanks|b" => \$ignore_trailing_blanks,
    "check|c" => \$check,
    "human-numeric-sort|h" => \$human_numeric_sort)
or die("Error in command line arguments\n");

if ($numeric_sort + $month_sort + $human_numeric_sort > 1) {
    die "Options are incompatible\n";
}

my @data;
for my $line (<STDIN>) {
    chomp $line;
    # s - replace $ - end of string (same sintax as sed)
    if ($ignore_trailing_blanks) {
        $line =~ s/\s+$//
    }
    my @cols = split / /,$line;
    push(@data, \@cols);
}

my $inc = 0;
my %months = map { $_, $inc++ }(
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC');

$inc = 0;
my %suffix = map { $_, 1024**($inc++) }(
    'K',
    'M',
    'G',
    'T',
    'P',
    'E'
);

my $cmp;
if ($human_numeric_sort) {
    $cmp = sub {
        substr($a->[$key], 0, -1) * $suffix{substr($a->[$key], -1)}
        <=>
        substr($b->[$key], 0, -1) * $suffix{substr($b->[$key], -1)};
    };
} elsif ($numeric_sort) {
    $cmp = sub { $a->[$key] <=> $b->[$key] };
} elsif ($month_sort) {
    $cmp = sub {
        my ($f, $s) = ($months{$a->[$key]}, $months{$b->[$key]});
        if ($f && $s) {
            $f <=> $s;
        } elsif (!$f) {
            -1;
        } elsif (!$s) {
            1;
        }
    };
} else {
    $cmp = sub { $a->[$key] cmp $b->[$key] };
};

my $isSorted = $check;
if ($check) {
    for (my ($prev_idx, $cur_idx) = (0, 1); $cur_idx <= $#data; $cur_idx++, $prev_idx++) {
        my ($f, $s);
        if ($reverse) {
            $f = $data[$cur_idx];
            $s = $data[$prev_idx];
        } else {
            $f = $data[$prev_idx];
            $s = $data[$cur_idx];
        };
        if ($cmp->($a = $f, $b = $s) > 0) {
            $isSorted = 0;
            last;
        };
    };
};

my @sorted_data;
if (!$isSorted) {
    if ($unique) {
        my %uniq;
        @sorted_data = sort($cmp grep {!$uniq{join(" ", @{$_})}++} @data );
    } else {
        @sorted_data = sort $cmp @data;
    }
    if ($reverse) {
        @sorted_data = reverse @sorted_data;
    }
} else {
    @sorted_data = @data;
}

for my $pline (@sorted_data) {
    print "@{$pline}\n";
}