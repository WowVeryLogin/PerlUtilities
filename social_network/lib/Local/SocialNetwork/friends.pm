package Local::SocialNetwork::friends;
use warnings;
use strict;
use 5.016;
use parent "Local::SocialNetwork";
use JSON;

sub make_request {
    my ($obj, $user1, $user2) = (@_);
    my $dbh = $obj->{_dbh};

    my $sth = $dbh->prepare("SELECT first_name, last_name FROM users
        WHERE id in (SELECT user_id FROM relations
        WHERE user_id = ? and friend_to in (
            SELECT friend_to FROM relations
            WHERE user_id = ?
        ));");
    $sth->execute($user1, $user2);

    my @res;
    while (my $res_ref = $sth->fetchrow_hashref()) {
        push(@res, {%{$res_ref}});
    };
    return encode_json(\@res);
}
1;