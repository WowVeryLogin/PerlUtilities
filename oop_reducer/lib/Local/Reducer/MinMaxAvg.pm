package Local::Reducer::MinMaxAvg;
use strict;
use warnings;
use Switch;
use 5.016;
use parent qw(Local::Reducer);

sub new {
    my $className = shift; 
    my %params = @_;
    my $obj = {};
    while (my ($key, $value) = each(%params)) {
        switch ($key) {
            case "initial_value" {
                $obj->{"reduced"} = $value;
            }
            case "row_class" {
                $obj->{"_row_class"} = $value;
            }
            case "source" {
                $obj->{"_source"} = $value;
            }
            case "field" {
                $obj->{"_field"} = $value;
            }
            else {
                panic("Unknown argument");
            }
        }
    }
	unless (ref $obj->{"reduced"} eq "HASH") {
		$obj->{"reduced"} = Local::Reducer::MinMaxAvg::Result->new();
	};
    bless $obj, $className;
    return $obj;
}

sub reduce_once {
    my $self = shift;
    my $row_parser = $self->{"_row_class"}->new((str => shift));
    if ($row_parser) {
        my $val = $row_parser->get($self->{"_field"}, undef);
		if ($val) {
			if (!defined($self->{"reduced"}->{"max"}) or $val >= $self->{"reduced"}{"max"}) {
				$self->{"reduced"}{"max"} = $val;
			} 
			if (!defined($self->{"reduced"}->{"min"}) or $val <= $self->{"reduced"}{"min"}) {
				$self->{"reduced"}{"min"} = $val;
			}
			if (!defined($self->{"reduced"}{"avg"})) {
				$self->{"reduced"}{"avg"} = $val;
				$self->{"reduced"}{"count"} = 1;
			} else {
				$self->{"reduced"}{"avg"} = ($self->{"reduced"}{"avg"} * $self->{"reduced"}{"count"} + $val) / ($self->{"reduced"}{"count"} + 1);
				$self->{"reduced"}{"count"}++;
			}
		}
    }
}
1;

package Local::Reducer::MinMaxAvg::Result;
sub new {
    my $className = shift;
	my $obj = {
		"max" => undef,
		"min" => undef,
		"avg" => undef,
		"count" => undef,
	};
	bless $obj, $className;
	return $obj;
}

sub get_max {
	return shift->{"max"};
}

sub get_min {
	return shift->{"min"};
}

sub get_avg {
	return shift->{"avg"};
}
1;