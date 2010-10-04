#use strict;
use warnings;

package pBot::Functions;


sub MSG {
	my($chan,$msg) = @_;
 	chomp($chan);
 	chomp($msg);
	&pBot::send_sock("PRIVMSG ".$chan." :".$msg."\n");
}

sub NOTICE {
	my($chan,$msg) = @_;
 	chomp($chan);
 	chomp($msg);
	&pBot::send_sock("NOTICE ".$chan." :".$msg."\n");
}

sub MODE {
	my($chan,$modes) = @_;
 	chomp($chan);
 	chomp($modes);
	&pBot::send_sock("MODE ".$chan." :".$modes."\n");
}

sub QUIT {
	my($msg) = @_;
 	chomp($msg);
	&pBot::send_sock("QUIT :".$msg."\n");
}

sub KICK {
	my($chan,$nick,$reason) = @_;
 	chomp($chan);
 	chomp($nick);
 	chomp($reason);
	&pBot::send_sock("KICK ".$chan." ".$nick." :".$reason."\n");
}

sub NICK {
	my($nick) = @_;
 	chomp($nick);
	&pBot::send_sock("NICK ".$nick."");
}

sub JOIN {
	my($chan,$key) = @_;
 	chomp($chan);
 	chomp($key);
	&pBot::send_sock("JOIN ".$chan." ".$key."\n");
}

sub PART {
	my($chan,$reason) = @_;
 	chomp($chan);
 	chomp($reason);
	&pBot::send_sock("PART ".$chan." ".$reason."\n");
}

1;