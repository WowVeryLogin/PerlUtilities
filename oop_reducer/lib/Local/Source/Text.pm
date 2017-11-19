package Local::Source::Text;
use strict;
use warnings;
use 5.016;

sub new {
    my $className = shift;
    my %params = @_;
    unless (defined $params{"text"}) {
        panic("require text param in constructor");
    }

    my $delim = $params{"delimiter"};
    $delim //= "\n";
    my $obj = {};
    $obj->{"_data"} = [split /$delim/, $params{"text"}];
    $obj->{"_pos"} = 0;
    bless $obj, $className;
    return $obj;
}

sub next($) {
    my $self = shift;
    return $self->{"_data"}->[$self->{"_pos"}++];
}
1;