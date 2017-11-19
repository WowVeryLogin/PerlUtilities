package Local::Reducer;

use strict;
use warnings;

=encoding utf8

=head1 NAME

Local::Reducer - base abstract reducer

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

sub new {
	my $class = shift;
}

sub reduce_n($$) {
    my $self = shift;
    my $n = shift;
    my $i = 0;
    while ($i++ < $n and my $cur_val = $self->{"_source"}->next()) {
        $self->reduce_once($cur_val)
    }
    return $self->{"reduced"};
}

sub reduce_all($) {
    my $self = shift;
    while (my $cur_val = $self->{"_source"}->next()) {
        $self->reduce_once($cur_val)
    }
    return $self->{"reduced"};
}

sub reduced($) {
    return shift->{"reduced"};
}
1;