#!/usr/bin/perl

# use module
use XML::Simple;

if($#ARGV < 1) {
	print "Usage: ./parsexml.pl filename parseparam\n";
	exit(0);
}

$filename = $ARGV[0];
$parseparam = $ARGV[1];
#print "Input param [filename=$filename] [parseparam=$parseparam]\n";

# create object
$xml = new XML::Simple;

# read XML file
my $doc = $xml->XMLin($filename);

# print output
#use Data::Dumper;
#print Dumper($doc);

# access XML data
print "$doc->{$parseparam}\n";
#$value = "NOT_FOUND";
#foreach $key (keys $doc) {
#	if($key eq $parseparam) {
#		$value = $doc->{$key};
#		break;
#	}
#}
#print "$value\n";
