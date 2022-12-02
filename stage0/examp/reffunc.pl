#!/usr/bin/perl
#
#
use Data::Dumper;

my @params = ('kent', 'mein');

sub print_name {
	my @values = @_;

	print "First name: $values[0]\n";
	print "Last name: $values[1]\n";
}

my $fun = \&print_name;

&$fun(@params);

print Dumper($fun);


