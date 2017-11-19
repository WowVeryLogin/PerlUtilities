package Local::Row::JSON;
use strict;
use warnings;
use 5.016;
use JSON;
use JSON::Validator;
use Scalar::Util qw(looks_like_number);

sub new {
    my $class_name = shift;
    my %params = @_;
    unless (defined $params{"str"}) {
        panic("require str param in constructor");
    }

    my $obj = eval { decode_json($params{"str"}) };
    if ($@ or !(ref $obj eq "HASH")) {
        return undef;
    }


    bless $obj, $class_name;
    return $obj;
}

sub get {
    my ($self, $field, $default) = @_;
    if (defined $self->{$field} and looks_like_number($self->{$field})) {
         return $self->{$field}
    } else {
        return $default;
    }
}
1;