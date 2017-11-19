#!/bin/env perl
use strict;
use warnings;
use 5.016;
use IO::Socket;
use Getopt::Long;

$| = 1;
STDIN->blocking(0);

my $use_udp = 0;
GetOptions ("udp|u" => \$use_udp)
    or die("Error in command line arguments\n");

my ($host, $port) = (@ARGV);
if (!$host or !$port) {
    die("Specify host and port for connection");
};

my $socket = IO::Socket::INET->new(
    PeerHost => "$host:$port",
    PeerPort => $port,
    Proto => ($use_udp ? 'udp' : 'tcp'),
    Timeout  =>  10,
    Blocking => 0)
or die "Can't connect to $host $/";

$socket->autoflush(1);

while (1) {
    my $send_data = <STDIN>;
    if ($send_data) {
        $socket->send($send_data) or die "Send error: $!\n";
    }

    my $recv_data = <$socket>;
    if ($recv_data) {
        print $recv_data;
    }
}
$socket->close();
