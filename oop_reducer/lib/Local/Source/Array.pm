package Local::Source::Array;
use strict;
use warnings;
use 5.016;

sub new {
    my $className = shift;
    my %array = @_;
    unless (defined $array{"array"}) {
        panic("require array param in constructor");
    }

    my $obj = {};
    $obj->{"_data"} = $array{"array"};
    $obj->{"_pos"} = 0;
    bless $obj, $className;
    return $obj;
}

sub next($) {
    my $self = shift;
    return $self->{"_data"}->[$self->{"_pos"}++];
}
1;