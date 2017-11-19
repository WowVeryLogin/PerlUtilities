package Local::SocialNetwork;

use strict;
use warnings;
use DBI;
use JSON;
use Cache::Memcached;

=encoding utf8
=head1 NAME
Local::SocialNetwork - social network user information queries interface
=head1 VERSION
Version 1.00
=cut

our $VERSION = '1.00';

=head1 SYNOPSIS
=cut

sub new {
    my $conf;
    {
        local $/=undef;
        open(my $cfg, "<", "etc/db.cfg") or die "No cfg file found\n";
        $conf = <$cfg>;
        close $cfg;
    }
    my $cfg = decode_json($conf);

    my $dbh = DBI->connect("dbi:Pg:dbname=$cfg->{dbname};host=$cfg->{host};port=$cfg->{port}",
        $cfg->{username},
        $cfg->{password},
        {AutoCommit => 1, RaiseError => 1}) or die $DBI::errstr;

    my $memd = Cache::Memcached->new({
        'servers' => [ $cfg->{memcache} ],
        'debug' => 0,
        'compress_threshold' => 10_000,
    });

    my $className = shift; 
    my $obj = {
        _memd => $memd,
        _dbh => $dbh
    };
    bless $obj, $className;
    return $obj;
}
1;
