# token TOP {
# 	^ [ <insert> | <select> ] $
# }
# 
# token insert {
# 	'INSERT' :s <parilist>
# }
# 
# tokent select {
# 	'SELECT' :s <keylist>
# 	[ 'WHERE' <parlist> ]?
# }

rule pairlist { <par>+ % [ ',' ] }
rule pair { <key> '=' <value> }
rule keylist { <key>+ % [ ',' ] }
token key { \w+ }

#token value { <integer> | <string> }
#token integer { \d+ }
#token string { \' <( <-[']>+ )> \' }

# Hard way non extensable
#method TOP($/) {
#	make $<select> ?? $<select>.ast !! $<insert>.ast;
#}
#
#method value($/) {
#	make $<integer> ?? $<integer>.ast !! $<string>.ast;
#}

token TOP { ^ <query> $ }

proto token query {*}
token query:sym<insert> {
	'INSERT' :s <parilist>
}

token query:sym<select> {
	'SELECT' :s <keylist>
	[ 'WHERE' <parilist> ]?
}

proto token value {*}
token value:sym<integer> { \d+ }
token value:sym<string> { \' <( <-[']>+ )> \' }

method TOP($/) {
	make $<query>.ast;
}

method value:sym<integer>($/) { make ~$/ }
method value:sym<string>($/) { make ~$/ }

method pairlist ($/) {
	my %pairs;
	for $<pair> -> $p {
		%pairs{$p<key>} := $p<value>.ast;
	}
	make %pairs;
}

method keylist($/) {
	my @keys;
	for $<key> -> $k {
		nqp::push(@keys, ~$k)
	}
	make @keys;
}

method query:sym<insert>($/) {
	my %to_insert := $<pairlist>.ast;
	make -> @db {
		nqp::push(@db, %to_insert);
		[nqp::hash('reslut', 'Inserted 1 row' )]
	};
}

class SlowDB {
	has @!data;

	method execute($query) {
		if QueryParser.parse($query, :actions(QueryActions)) -> $parsed {
			my $evaluator := $parsed.ast;
			if $evaluator(@!data) -> @results {
				for @results -> %data {
					say("[");
					say("	{$_.key}: {$_.value}") for %data;
					say("]");
				}
			} else {
				say("Nothing found");
			}
		}
	}
}


