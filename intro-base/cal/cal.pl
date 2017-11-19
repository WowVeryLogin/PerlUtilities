#!/usr/bin/env perl

use 5.016;
use warnings;
use Time::Local 'timelocal';

sub days_in_month {
	my ($month, $year) = @_;
	++$month;
	return 30 + ($month + ($month > 7)) % 2 - ($month == 2) *
	(2 - ($year % 4 == 0 && ($year % 100 != 0 || $year % 400 == 0)));
}

my @week_days = qw(Su Mo Tu We Th Fr Sa);
my @months_name = qw(
	January February March 
	April May June July
	August September October
	November December);

sub print_cal_for_month {
	my ($mday, $wday, $month, $year) = @_;
	#печатаем заголовок с месяцем и годом
	say "   $months_name[$month] $year";
	#печатаем названия дней недели
	for my $week_day (@week_days) {
		print($week_day, ' ');
	}
	print "\n";

	print '   ' for (1 .. $wday);

	for my $day_count (1 .. days_in_month($month, $year)) {
		if (not($wday % 7) && $day_count != 1) {
			print "\n";
		}
		printf ("%2d ",$day_count);
		++$wday;
	}
	print "\n";
}

if (@ARGV == 1) {
	my ($month) = @ARGV;
	# нам передали номер месяца. проверяем параметр
	if ($month < 1 or $month > 12) {
		die "Month is out of range"
	}
	my $year = 1900 + (localtime)[5];
	my $begin_of_month	= timelocal(0, 0, 0, 1, $month - 1, $year);
	my ($mday, $wday) = ((localtime($begin_of_month))[3], (localtime($begin_of_month))[6]);
	# печатаем календарь на этот месяц
	print_cal_for_month($mday, $wday, $month - 1, $year);
} elsif (not @ARGV) {
	my ($month, $year) = ((localtime)[4], 1900 + (localtime)[5]);
	my $begin_of_month	= timelocal(0, 0, 0, 1, $month, $year);
	my ($mday, $wday) = ((localtime($begin_of_month))[3], (localtime($begin_of_month))[6]);
	# печатаем календарь на этот месяц
	print_cal_for_month($mday, $wday, $month, $year);
} else {
	# неверное количество аргументов
	die "Too much arguments"
}
