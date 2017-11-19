package Local::SocialNetwork::nofriends;
use warnings;
use strict;
use 5.016;
use parent "Local::SocialNetwork";
use JSON;

sub make_request {
    my $obj = shift;
    my $dbh = $obj->{_dbh};

    my $sth = $dbh->prepare("SELECT users.id, first_name, last_name
        FROM USERS LEFT JOIN RELATIONS ON users.id = relations.user_id
        WHERE relations.id is null;");
    $sth->execute();

    my @res;
    while (my $res_ref = $sth->fetchrow_hashref()) {
        push(@res, {%{$res_ref}});
    };
    return encode_json(\@res);
}
1;