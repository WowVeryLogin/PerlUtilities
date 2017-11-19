#!/bin/env perl
use strict;
use warnings;
use 5.016;
use Getopt::Long;

use FindBin; use lib "$FindBin::Bin/../lib";
use Local::SocialNetwork::nofriends;
use Local::SocialNetwork::friends;
use Local::SocialNetwork::num_handshakes;

my ($nofriends, $friends, $num_handshakes) = (0)x3;
my $users = [];
GetOptions ("nofriends" => \$nofriends,
    "friends" => \$friends,
    "num_handshakes" => \$num_handshakes,
    "user=i@" => \$users)
or die("Error in command line arguments\n");

if (($friends or $num_handshakes) and @{$users} != 2) {
    die("Error in command line arguments\n");
}

if ($nofriends) {
    my $res = Local::SocialNetwork::nofriends->new();
    say $res->make_request();
}

if ($friends) {
    my $res = Local::SocialNetwork::friends->new();
    say $res->make_request($users->[0], $users->[1]);
}

if ($num_handshakes) {
    my $res = Local::SocialNetwork::num_handshakes->new();
    say $res->make_request($users->[0], $users->[1]);
}

