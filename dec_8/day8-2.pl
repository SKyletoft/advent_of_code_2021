#!/usr/bin/perl
use strict;
use warnings;

# $of, $val
sub is_subset {
	my $of      = $_[0];
	my $val     = $_[1];
	my @letters = split("", $val);
	for my $letter (@letters) {
		my $res = index($of, $letter);
		if ($res == -1) {
			return 0;
		}
	}
	return 1;
};

sub is_anagram {
	my $of = $_[0];
	my $val = $_[1];
	if (length($of) != length($val)) {
		return 0;
	}
	return is_subset($of, $val);
}

my $outer_sum = 0;
for my $lines (<>) {
	my @halves = split(/ \| /, $lines);
	my @first  = split(" ", $halves[0]);
	my %found  = (
		one   => "",
		two   => "",
		three => "",
		four  => "",
		five  => "",
		six   => "",
		seven => "",
		eight => "",
		nine  => "",
		zero  => ""
	);

	for my $word (@first) {
		$found{one}   = $word if (length($word) == 2);
		$found{four}  = $word if (length($word) == 4);
		$found{seven} = $word if (length($word) == 3);
		$found{eight} = $word if (length($word) == 7);

	}
	@first = grep {$_ ne $found{one}}   @first;	
	@first = grep {$_ ne $found{four}}  @first;	
	@first = grep {$_ ne $found{seven}} @first;	
	@first = grep {$_ ne $found{eight}} @first;	

	for my $word (@first) {
		if (length($word) == 5) {
			$found{three} = $word if is_subset($word, $found{seven});
		}
	}
	@first = grep {$_ ne $found{three}} @first;	

	for my $word (@first) {
		if (length($word) == 6) {
			$found{nine} = $word if is_subset($word, $found{three});
		}
	}
	@first = grep {$_ ne $found{nine}} @first;	

	for my $word (@first) {
		if (length($word) == 6) {
			$found{zero} = $word if is_subset($word, $found{seven});
		}
	}
	@first = grep {$_ ne $found{zero}} @first;

	for my $word (@first) {
		if (length($word) == 6) {
			$found{six} = $word;
		}
	}
	@first = grep {$_ ne $found{six}} @first;	

	for my $word (@first) {
		if (length($word) == 5) {
			$found{five} = $word if is_subset($found{six}, $word);
		}
	}
	@first = grep {$_ ne $found{five}} @first;	

	$found{two} = $first[0] if scalar(@first) == 1;
	@first = grep {$_ ne $found{two}} @first;

	#-------------------------------------------------------------------
	
	my @second = split(" ", $halves[1]);
	my $sum = 0;
	for my $word (@second) {
		$sum = 10 * $sum;
		if (is_anagram($word, $found{zero})) {
			$sum = $sum + 0;
		}
		elsif (is_anagram($word, $found{one})) {
			$sum = $sum + 1;
		}
		elsif (is_anagram($word, $found{two})) {
			$sum = $sum + 2;
		}
		elsif (is_anagram($word, $found{three})) {
			$sum = $sum + 3;
		}
		elsif (is_anagram($word, $found{four})) {
			$sum = $sum + 4;
		}
		elsif (is_anagram($word, $found{five})) {
			$sum = $sum + 5;
		}
		elsif (is_anagram($word, $found{six})) {
			$sum = $sum + 6;
		}
		elsif (is_anagram($word, $found{seven})) {
			$sum = $sum + 7;
		}
		elsif (is_anagram($word, $found{eight})) {
			$sum = $sum + 8;
		}
		elsif (is_anagram($word, $found{nine})) {
			$sum = $sum + 9;
		}
	}
	$outer_sum += $sum;
}

print "$outer_sum\n";

