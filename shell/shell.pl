#!/bin/env perl
use strict;
use warnings;
use 5.016;
use Cwd;

$|=1;
my $path_delimeter = qr/\//;
my $pipe_delim = qr/\|/;
my @paths = split(/:/, $ENV{'PATH'});

sub print_greeting {
    my ($username, $current_path) = (getlogin(), getcwd());
    $username //= ".";
    my @path_splitted = split($path_delimeter, $current_path);
    my $current_dir = pop(@path_splitted);
    print "[$username\@$current_dir]\$ ";
}

sub parse_command {
    my $line = shift;
    return [grep {$_} split(/\s+/, $line)];
}

sub ps {
    my $w = shift;
    my $format = "%-8s %-6s %-8s %-24s\n";
    printf $w $format,
        "PID",
        "PPID",
        "STATE",
        "CMD";
    opendir(my $proccesses, "/proc") or die "Unable to open /proc:$!\n";
    while (my $pd = readdir($proccesses)) {
        next if ($pd eq "." or $pd eq "..");
        my %pdata;

        open(my $pstatus, "<", "/proc/$pd/status") or next;
        while (my $line = <$pstatus>) {
            if ($line =~ /State:\s+(\w).*/) {
                $pdata{"state"} = $1;
            } elsif ($line =~ /Name:\s+(.*)/) {
                $pdata{"name"} = $1;
            } elsif ($line =~ /PPid:\s+(.*)/) {
                $pdata{"ppid"} = $1;
            }
            if (keys(%pdata) == 4) {
                last;
            }
        }
        close($pstatus);

        next if ($pdata{"state"} eq "S");
        my $username = getpwuid((lstat "/proc/$pd")[4]);
        printf $w $format,
            $username,
            $pdata{"ppid"},
            $pdata{"state"},
            $pdata{"name"};
    }
    closedir($proccesses);
}

my $inner_commands = {
    cd => sub {
        my ($r, $w, $arg) = (@_);
        if (-d $arg) {
            my $res = chdir($arg);
        } else {
            print $w "cd: $arg: No such file or directory\n";
        }
    },
    pwd => sub {
        my ($r, $w, $arg) = (@_);
        print $w getcwd() . "\n";
    },
    echo => sub {
        my ($r, $w, $arg) = (@_);
        print $w "$arg\n";
    },
    kill => sub {
        my ($r, $w, @args) = (@_);
        kill(@args);
    },
    ps => sub {
        my ($r, $w, @args) = (@_);
        ps($w)
    } 
};

sub exec_with_io {
    my ($r, $w, $command, @args) = (@_); 
    if (!($r eq "*main::STDIN")) {
        close(STDIN);
        open(STDIN, "<&", \$r);
    }
    if (!($w eq "*main::STDOUT")) {
        close(STDOUT);
        open(STDOUT, ">&", \$w);
    }
    exec("$command", @args);
}

sub run_command {
    my ($r, $w, $command_with_args) = (@_);
    my ($command_name, @args) = (@{$command_with_args});
    if ($command_name =~ /^\.\/(.*)/) {
        if (-e (getcwd() . "/" . $1)) {
            exec_with_io($r, $w, $command_name, @args);
        } else {
            print $w "$command_name: command not found...\n";
        }
    } else {
        for my $path (@paths) {
            if (-e ($path . "/" . "$command_name")) {
                exec_with_io($r, $w, $path . "/" . "$command_name", @args);
            }
        }
        print $w "$command_name: command not found...\n";
    }
}

print_greeting();

while (<>) {
    chomp;
    my @commands = split($pipe_delim, $_);
    my @ptowait;
    my $prev = *STDIN;
    my $n = $#commands;
    for my $command (@commands) {
        my ($r, $w);
        if ($n--) {
            pipe($r, $w);
        } else {
            $w = *STDOUT;
        }
        my $command_with_args = parse_command($command);
        my ($command_name, @args) = @{$command_with_args};
        if (exists($inner_commands->{$command_name})) {
            $inner_commands->{$command_name}($prev, $w, @args);
        } else {
            if (my $pid = fork()) {
                if ($#commands) {
                    push(@ptowait, $pid);
                } else {
                    waitpid($pid, 0);
                }
            } else {
                die "Cannot fork $!" unless defined $pid;
                run_command($prev, $w, $command_with_args);
                exit;
            }
        }
        $prev = $r;
    }
    for my $pid (@ptowait) {
        waitpid($pid, 0);
    }
    print_greeting();
}