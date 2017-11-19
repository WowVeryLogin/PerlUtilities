#!/usr/bin/env perl

use 5.016;
use warnings;

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
my $to_hour = (60 - $min) * 60 - $sec;
my $to_day = (23 - $hour) * 60 * 60 + $to_hour;
my $to_week = (6 - ($wday + 6) % 7) * 60 * 60 * 24 + $to_day;
say "Seconds to hour $to_hour, day $to_day, week $to_week";