#!/usr/bin/perl
use strict;
use warnings;

my $sum   = 0;

for my $lines (<>) {
	my @halves = split(/ \| /, $lines);
	my $after = $halves[1];
	for my $word (split(" ", $after)) {
		$sum = $sum + 1 if (length($word) eq 2);
		$sum = $sum + 1 if (length($word) eq 3);
		$sum = $sum + 1 if (length($word) eq 4);
		$sum = $sum + 1 if (length($word) eq 7);
	}
}

print "$sum\n";

