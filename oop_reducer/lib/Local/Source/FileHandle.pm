package Local::Source::FileHandle;
use strict;
use warnings;
use 5.016;

sub new {
    my $className = shift;
    my %params = @_;
    unless (defined $params{"fh"}) {
        panic("require fh param in constructor");
    }

    my $obj = {};
    $obj->{"_data"} = $params{"fh"};
    bless $obj, $className;
    return $obj;
}

sub next($) {
    my $self = shift;
    my $res = readline($self->{"_data"});
    if ($res) {
        chomp $res;
    }
    return $res;
}
1;