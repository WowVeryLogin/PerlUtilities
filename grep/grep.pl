#!/usr/bin/env perl
use 5.016;
use warnings;
use Getopt::Long;
use IO::Handle;

my ($after,
	$before,
	$context,
	$count,
	$ignore_case,
	$invert,
	$fixed,
	$line_number) = (0)x8;

GetOptions ("after-context|A=i" => \$after,
	"before-context|B=i" => \$before,
	"context|C=i" => \$context,
	"count|x" => \$count,
	"ignore-case|i" => \$ignore_case,
	"invert-match|v" => \$invert,
	"fixed-strings|F" => \$fixed,
	"line-number|n" => \$line_number)
or die("Error in command line arguments\n");

if (@ARGV != 1) {
	die("Wrong pattern")
}
my $pattern = shift;
if ($fixed) {
	$pattern = quotemeta($pattern)
}
my $regexp = $ignore_case ? qr/$pattern/i : qr/$pattern/;


my @context_buffer;
my ($print_next, $buf_size) = (0, $context ? $context : $before);
my $total = 0;

while (my $line = <STDIN>) {
	chomp $line;
	my $res = $invert ? $line !~ $regexp : $line =~ $regexp;
	if (!$count) {
		if ($res) {
			while (my $buf_line = shift @context_buffer) {
				$line_number ? say "$. $buf_line" : say "$buf_line";
			}
			$line_number ? say "$. $line" : say "$line";
			$print_next = $context ? $context : $after;
		} elsif ($print_next) {
			$print_next--;
			$line_number ? say "$. $line" : say "$line";
		} else {
			if (@context_buffer > $buf_size) {
				shift @context_buffer;
			}
			push @context_buffer, $line;
		}
	} elsif ($res) {
		$total++;
	}
}

if ($count) {
	say $total;
}