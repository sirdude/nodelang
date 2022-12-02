#!/usr/bin/perl

use strict;
use warnings;

my (%data, %types, %params, %funcs);

sub dataset {
	my ($sym, $type, $value) = @_;
	$types{$sym} = $type;
	$data{$sym} = $value;
}

sub dataexists {
	my ($sym) = @_;

	return exists($data{$sym});
}

sub dataget {
	my ($sym) = @_;

	return $data{$sym};
}

sub datadump {
	my ($i) = @_;

	my $type = $types{$i};
	if ($type eq 'string') {
		print "dataset(\'$i\', '"  . $types{$i} . "', '" . $data{$i} . "')\n";
	} else {
		print "dataset(\'$i\', '"  . $types{$i} . "', " . $data{$i} . ")\n";
	}
}

sub print_params {
	my ($name) = @_;

	return '"' . $params{$name} . '"';
}

sub print_func {
	my ($name) = @_;

	return "'" . $funcs{$name} . "'";
}

sub funcadd {
	my ($name, $p, $code) = @_;

	$params{$name} = $p;
	$funcs{$name} = $code;
}

sub funcdump {
	my ($i) = @_;

	print "funcadd('" . $i . "', " .
		print_params($i) . ", " .
		print_func($i) . ")\n";
}

sub mydump {
	print "use node\n\n";
	foreach my $i (keys %data) {
		datadump($i);
	}
	print "\n";

	foreach my $i (keys %funcs) {
		funcdump($i);
	}
}

dataset('name', 'string', 'node');
dataset('description', 'string', 'Our base node');

my $input = "('name', 'value')";
funcadd('dataset', $input, 'funref');

$input = "('name')";
funcadd('dataexists', $input, 'funref');

$input = "('name')";
funcadd('dataget', $input, 'funref');

$input = "('name')";
funcadd('datadump', $input, 'funref');

$input = "('name')";
funcadd('datadelete', $input, 'funref');

$input = "('name', 'params', 'code')";
funcadd('funcadd', $input, 'funref');

$input = "('name')";
funcadd('funcexists', $input, 'funref');

$input = "('name')";
funcadd('funcdelete', $input, 'funref');

$input = "('name')";
funcadd('funcdump', $input, 'funref');

$input = "('name', 'params')";
funcadd('funcexecute', $input, 'funref');

mydump();
