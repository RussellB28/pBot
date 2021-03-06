#use strict;
use warnings;

package pBot::Commands;


sub cmd_eval {
	my($owner,$chan,$cmd,$message) = @_;
 	chomp($owner);
 	chomp($chan);
 	chomp($cmd);
 	chomp($message);
	$onick = &pBot::config('me', 'onick');
	if($owner =~ m/($onick)/)
	{
		eval($message);
		&pBot::Functions::MSG($chan,"3[SUCCESS] Evaluated Code");
	}
	else
	{
		&pBot::Functions::MSG($chan,"4[FAILURE] You not have permission to use this command");
	}
}

sub cmd_uptime {
	my($owner,$chan,$cmd,$varz) = @_;
 	chomp($owner);
 	chomp($chan);
 	chomp($cmd);
 	chomp($varz);

	if(&pBot::trim($varz) =~ m/BOT/)
	{
		&pBot::Functions::MSG($chan,"2[UPTIME] FML: Unavailable");
	}
	elsif(&pBot::trim($varz) =~ m/SYSTEM/)
	{
		$result = `uptime`;
		&pBot::Functions::MSG($chan,"2[UPTIME] System: ".$result);
	}
	else
	{
		&pBot::Functions::MSG($chan,"4[FAILURE] Syntax: !uptime [SYSTEM | BOT]");
	}
}

sub cmd_stest {
	my($owner,$chan,$cmd,$message) = @_;
 	chomp($owner);
 	chomp($chan);
 	chomp($cmd);
 	chomp($message);

	$result = `uptime`;
	&pBot::Functions::MSG($chan,"4[SERVER-CMD] Connection to ".&pBot::config('server','host')." is still established");
}

sub cmd_dns {
	my($owner,$chan,$cmd,$message) = @_;
 	chomp($owner);
 	chomp($chan);
 	chomp($cmd);
 	chomp($message);

	&pBot::DNS::get_record_a($owner,$chan,$cmd,$message);
}

1;