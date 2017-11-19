package Local::SocialNetwork::num_handshakes;
use warnings;
use strict;
use 5.016;
use parent "Local::SocialNetwork";

sub BFS {
    my ($user_id, $goal_id, $dbh) = (@_);
    my @queue = ($user_id);
    my $num_handshakes = 0;
    my %visited;

    while (@queue) {
        $num_handshakes++;
        my @tmp_queue;
        for my $friend (@queue) {
            my $sth = $dbh->prepare("SELECT friend_to FROM relations WHERE user_id = ?;");
            $sth->execute($friend);
            my @friends = grep {!$visited{$_}++} map {$_->[0]} @{$sth->fetchall_arrayref()};
            for my $friend_to (@friends) {
                if ($friend_to == $goal_id) {
                    return $num_handshakes;
                }
                push @tmp_queue, $friend_to;
            }
        }
        @queue = @tmp_queue;
    }
    return 0;
}

sub make_request {
    my ($obj, $user1, $user2) = (@_);
    my ($dbh, $memd) = ($obj->{_dbh}, $obj->{_memd});

    my $sth = $dbh->prepare("SELECT max(ts) FROM relations;");
    $sth->execute();
    my $new_last_ts = $sth->fetchrow_array();
    my $last_ts = $memd->get("last_ts");
    if (!$last_ts or $new_last_ts > $last_ts) {
        $memd->flush_all();
        $memd->set("last_ts", $new_last_ts);
    }
    my $key = "$user1\_$user2";
    my $res = $memd->get($key);
    if ($res) {
        return $res;
    } else {
        my $res = BFS($user1, $user2, $dbh);
        $memd->set($key, $res);
        return $res;
    }
}
1;