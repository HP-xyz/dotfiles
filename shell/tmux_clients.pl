#!/usr/bin/perl

my $sock="";
$sock = "-S ".$ARGV[0] if $ARGV[0];

my $clients = `tmux $sock list-clients`;

# Use open to loop like a file
open my $fh, '<', \$clients or die $!;

printf("%-10.10s\t%-10.10s\t%-10.10s\t%-16.16s\t%s\n", "Session", "TTY", "Username", "Timestamp", "Origin");
while(<$fh>) {
    my @cols = split(' ');
    my ($tty) = $cols[0] =~ /^\/dev\/(pts\/\d+)/;
    my $session = $cols[1];
    my $who = `who | grep $tty`;
    my @whoc = split(' ',$who);

    printf("%-10.10s\t%-10.10s\t%-10.10s\t%-16.16s\t%s\n", $session,$tty,$whoc[0], "$whoc[2] $whoc[3]", $whoc[4]);
}
