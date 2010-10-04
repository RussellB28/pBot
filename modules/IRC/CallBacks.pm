#use strict;
use warnings;

package pBot::CallBacks;


sub irc_connect {
	&pBot::send_sock("USER ".&pBot::config('me', 'ident')." * * :".&pBot::config('me', 'name')."\n");
	&pBot::Functions::NICK(&pBot::config('me', 'nick'));
}

sub irc_onconnect {
	&pBot::send_sock("MODE ".&pBot::config('me', 'nick')." ".&pBot::config('me', 'modes')."\n");
	&pBot::Functions::MSG("NickServ","IDENTIFY ".&pBot::config('me', 'pass')."");
	&pBot::Functions::JOIN(&pBot::config('me', 'chan'),"null");
}

sub irc_onchanjoin {
	my($chan) = @_;
 	chomp($chan);
	&pBot::Functions::MSG($chan,"I have joined ".$chan."");
}

sub irc_onchanpart {
	my($chan) = @_;
 	chomp($chan);
	# Reserved for Future Use
}

sub irc_onchaninvite {
	my($chan) = @_;
 	chomp($chan);
	&pBot::Functions::JOIN($chan,"null");
	&pBot::Functions::MSG($chan,"Hey, i am now in ".$chan." because i was invited!");
}

sub irc_onchankick {
	my($chan) = @_;
 	chomp($chan);
	&pBot::Functions::JOIN($chan,"null");
	&pBot::Functions::MSG($chan,"Hey, don't kick me you retard!");
}

sub irc_onprivmsg {
	my($owner,$chan,$cmd,$message) = @_;
 	chomp($owner);
 	chomp($chan);
 	chomp($cmd);
 	chomp($message);

	print("[DEBUG] ".$owner." --> [".$chan."] ".$cmd."\n");
	
	if($cmd=~ m/!codeeval/)
	{
		if(defined($message))
		{
		&pBot::Commands::cmd_eval($owner,$chan,$cmd,$message);
		}
		else
		{
		&pBot::Functions::MSG($chan,"4[FAILURE] Syntax: !codeeval [PERL CODE]");
		}
	}

	if($cmd=~ m/!uptime/)
	{
		if(defined($message))
		{
		&pBot::Commands::cmd_uptime($owner,$chan,$cmd,$message);
		}
		else
		{
		&pBot::Functions::MSG($chan,"4[FAILURE] Syntax: !uptime [SYSTEM | BOT]");
		}
	}

	if($cmd=~ m/!stest/)
	{
		&pBot::Commands::cmd_stest($owner,$chan,$cmd,$message);
	}

	if($cmd=~ m/!dns/)
	{
		&pBot::Commands::cmd_dns($owner,$chan,$cmd,$message);
	}
}

sub irc_onping {
	my($x) = @_;
 	chomp($x);
	&pBot::send_sock("PONG ".$x."\n");
    	print("[BOT-RAW] PONG ".$x."\r\n");
}

1;
