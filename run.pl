#!/usr/bin/perl


#use strict;
use warnings;
use lib 'modules';
package pBot;
use IO::Socket;
use Net::DNS;
use Config::Scoped;
use IRC::CallBacks;
use IRC::Functions;
use Bot::Commands;
our $VERSION = "1.0a";
our (%rawcmds, %timers, %COMMANDS);
our $c_netop;

# Get configuration values
my $conf = Config::Scoped->new(
    file => "bot.conf",
) or error("bot", "We couldn't open the config file!\n");

# Put them into variables	
my $settings = $conf->parse;

# Open the socket
my $socket = IO::Socket::INET->new(
    Proto => "tcp",
    LocalAddr => config('server', 'vhost'),
    PeerAddr => config('server', 'host'),
    PeerPort => config('server', 'port'),
) or error("bot", "Connection to ".config('server', 'host')." failed.\n");


# Connect!
#irc_connect();


# Throw the program into an infinite while loop
while (1) {
	$data = <$socket>;
	unless (defined($data)) {
		sleep 3;
		$socket = IO::Socket::INET->new(
			Proto => "tcp",
			LocalAddr => config('server', 'vhost'),
			PeerAddr => config('server', 'host'),
			PeerPort => config('server', 'port'),
		) or error("bot", "Connection to ".config('server', 'host')." failed.\n");
		&pBot::CallBacks->irc_connect();
	}

    chomp($data);
    undef $ex;
    @ex = split(' ', $data);

    print("[IRC-RAW] ".$data."\n");
    $USER = substr($ex[0], 1);
	$bnick = config('me', 'nick');

        if ($data =~ m/Found your hostname/) {
		&pBot::CallBacks::irc_connect();
	 }

        if ($data =~ m/MODE ($bnick)/) {
		&pBot::CallBacks::irc_onconnect();
	 }

        if ($ex[1] eq "JOIN") {
		$ex[2] =~ s/://g;
		&pBot::CallBacks::irc_onchanjoin($ex[2]);
	 }

        if ($ex[1] eq "INVITE") {
		$ex[3] =~ s/://g;
		&pBot::CallBacks::irc_onchaninvite($ex[3]);
	 }

        if ($ex[1] eq "249") {
		$ex[0] =~ s/://g;
		#$ex[3] =~ s/://g;
		my($argz) = substr($ex[3], 1);
		my ($i);
    		for ($i = 4; $i < count(@ex); $i++) { $argz .= ' '.$ex[$i]; }
		&pBot::send_sock("PRIVMSG ".$c_netop." :".$argz."\n");
	 }

        if ($ex[1] eq "KICK" && $ex[3] == $bnick) {
		&pBot::CallBacks::irc_onchankick($ex[2]);
	 }

        if ($ex[1] eq "PRIVMSG") {
		$ex[0] =~ s/://g;
		$ex[3] =~ s/://g;
		my($argz) = substr($ex[4], 1);
		my ($i);
    		for ($i = 4; $i < count(@ex); $i++) { $argz .= ' '.$ex[$i]; }
		&pBot::CallBacks::irc_onprivmsg($ex[0],$ex[2],$ex[3],$argz);
	 }


        if ($ex[0] eq "PING") {
		&pBot::CallBacks::irc_onping($ex[1]);
	 }


    if ($ex[0] eq 'CAPAB' and $ex[1] eq 'MODULES' and lc(config('server', 'ircd')) eq 'inspircd') {
        # stop if m_invisible is loaded, this will not be removed - so don't ask
        if ($data =~ m/m_invisible.so/) {
	     send_sock("QUIT :m_invisible.so appears to be loaded on this server. We do not allow our bot to be used on such networks!");
            error("bot", "We forbid the use of TIRCu with InspIRCd with m_invisible.so loaded, please unload it then try again!");
        }
        # check for m_servprotect
        if ($data =~ m/m_servprotect.so/) {
            $INSPIRCD_SERVICE_PROTECT_MOD = 1;
        }
    }
    # InspIRCd: CAPAB END recieved
     elsif ($ex[0] eq 'CAPAB' and $ex[1] eq 'END' and lc(config('server', 'ircd')) eq 'inspircd') {
    #     if ($INSPIRCD_SERVICE_PROTECT_MOD != 1) {
    #         error("tircu", "When using TIRCu with InspIRCd, m_servprotect.so is needed, please load it and try again!");
    #     }
    	   $socket->send("JOIN ".config('me', 'chan'));
    	   print("[BOT-RAW] JOIN ".config('me', 'chan')."\r\n");
    	   $socket->send("PRIVMSG ".config('me', 'chan')." :[DEB] Recieved CAPAB END");
    	   print("[BOT-RAW] PRIVMSG ".config('me', 'chan')." :[DEB] Recieved CAPAB END \r\n");
     }

    # Handle a server command, if a handler is defined in the protocol module
    if ($rawcmds{$ex[1]}{handler}) 
    {
        my $sub_ref = $rawcmds{$ex[1]}{handler};
        eval 
        {
            &{ $sub_ref }($data);
        };
    }
}



sub send_sock {
    my ($str) = @_;
    chomp($str);
    send($socket, $str."\r\n", 0);
    print("[BOT-RAW] ".$str."\n");
}

sub config {
    my ($block, $name) = @_;
    $block = lc($block);
    $name = lc($name);
    if (defined $settings->{$block}->{$name}) 
    {
        return $settings->{$block}->{$name};
    } else 
    {
        return 0;
    }
}

sub count {
	my (@array) = @_;
	my ($i, $ai);
	foreach $ai (@array) {
		$i += 1;
	}
	return $i;
}

sub trim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}



