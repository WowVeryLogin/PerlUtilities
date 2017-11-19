package Local::Reducer::MaxDiff;
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
            case "top" {
                $obj->{"_top"} = $value;
            }
            case "bottom" {
                $obj->{"_bottom"} = $value;
            }
            else {
                panic("Unknown argument");
            }
        }
    }
    bless $obj, $className;
    return $obj;
}

sub reduce_once {
    my $self = shift;
    my $row_parser = $self->{"_row_class"}->new((str => shift));
    if ($row_parser) {
        my $top = $row_parser->get($self->{"_top"}, undef);
        my $bottom = $row_parser->get($self->{"_bottom"}, undef);
        if (defined($top) && defined($bottom)) {
            my $new_diff = $top - $bottom;
            $self->{"reduced"} = $self->{"reduced"} < $new_diff ? $new_diff : $self->{"reduced"};
        }
    }
}
1;