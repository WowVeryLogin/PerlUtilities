#!/bin/env perl
use strict;
use warnings;
use 5.016;
use DBI;

my $dbname = "friendship";
my $host = "127.0.0.1";
my $port = "5432";
my $username = "postgres";
my $password = "";
my $dbh = DBI->connect("dbi:Pg:dbname=$dbname;host=$host;port=$port",
    $username,
    $password,
    {AutoCommit => 0, RaiseError => 1}) or die $DBI::errstr;

binmode(STDOUT, ":utf8");

open(my $userfile, "<::utf8", "user");
while (my $line = <$userfile>) {
    $line =~ m/^(\d+)\s(\w+)\s(\w+)$/;
    my $sth = $dbh->prepare('INSERT INTO USERS VALUES (?, ?, ?);');
    $sth->execute($1, $2, $3);
}
$dbh->commit();
close($userfile);

open(my $relationfile, "<::utf8", "user_relation");
my ($count, $ts) = (1, time());
while (my $line = <$relationfile>) {
    $line =~ m/^(\d+)\s(\d+)$/;
    my $sth = $dbh->prepare('INSERT INTO RELATIONS VALUES (?, ?, ?, ?);');
    $sth->execute($count++, $1, $2, $ts);
    $dbh->commit() or next;
}
close($relationfile);