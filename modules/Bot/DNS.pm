#use strict;
use warnings;

package pBot::DNS;


sub get_record_a {

	my($owner,$chan,$cmd,$varz) = @_;
	my $res = new Net::DNS::Resolver;
	my $query = $res->search($varz, "A");
	my $rr;

	if ($query) {
		&pBot::Functions::MSG($chan, "\002 ** IPv4 Addresses Found ** \002");
		&pBot::Functions::MSG($chan, "Records found for: ".$varz);

      		foreach $rr ($query->answer) {
          		next unless $rr->type eq "A";
			&pBot::Functions::MSG($chan, ">> ".$rr->address);
      		}
		&pBot::Functions::MSG($chan, "\002 ************************** \002");
		return;
  	}
  	else {
		&pBot::Functions::MSG($chan, "DNS Query Failed: ".$res->errorstring);
		return;
  	}

}