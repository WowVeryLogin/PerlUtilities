package Local::Row::Simple;
use strict;
use warnings;
use 5.016;
use Data::Dumper;

sub new {
    my $class_name = shift;
    my %params = @_;

    unless (defined $params{"str"}) {
        panic("require str param in constructor");
    }
    
    my $obj = {};
    unless ($params{"str"}) {
        bless $obj, $class_name;
        return $obj;
    }

    my @fields = map {split(/:/, $_)} split(/,/ , $params{"str"});
    if (@fields and (scalar @fields % 2 == 0)) {
        $obj = {(@fields)};
    } else {
        return undef;
    }
    bless $obj, $class_name;
    return $obj;
}

sub get {
    my ($self, $field, $default) = @_;
    defined $self->{$field} ? return $self->{$field} : return $default;
}
1;