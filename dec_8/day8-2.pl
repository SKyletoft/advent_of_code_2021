#!/usr/bin/perl
use strict;
use warnings;

# $of, $val
sub is_subset {
	my $of = $_[0];
	my $val = $_[1];
	my @letters = split("", $val);
	for my $letter (@letters) {
		my $res = index($of, $letter);
		if ($res == -1) {
			return 0;
		}
	}
	return 1;
};

for my $lines (<>) {
	my @halves = split(/ \| /, $lines);
	my %found = (
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
	my @first = split(" ", $halves[0]);

	for my $word (@first) {
		$found{one}   = $word if (length($word) == 2);
		$found{four}  = $word if (length($word) == 4);
		$found{seven} = $word if (length($word) == 3);
		$found{eight} = $word if (length($word) == 7);

	}
	@first = grep {$_ ne $found{one}} @first;	
	@first = grep {$_ ne $found{four}} @first;	
	@first = grep {$_ ne $found{seven}} @first;	
	@first = grep {$_ ne $found{eight}} @first;	

	for my $word (split(" ", @first)) {
		if (length($word) == 5) {
			$found{three} = $word if is_subset($word, $found{seven});
		}
	}
	@first = grep {$_ ne $found{three}} @first;	

	for my $word (split(" ", @first)) {
		if (length($word) == 6) {
			$found{nine} = $word if is_subset($word, $found{three});
		}
	}
	@first = grep {$_ ne $found{nine}} @first;	

	for my $word (split(" ", @first)) {
		if (length($word) == 6) {
			$found{zero} = $word if is_subset($word, $found{seven});
		}
	}
	@first = grep {$_ ne $found{zero}} @first;

	for my $word (split(" ", @first)) {
		if (length($word) == 6) {
			$found{six} = $word;
		}
	}
	@first = grep {$_ ne $found{six}} @first;	

	print "-----------------\n";

	for my $key (@first) {
		print "$key\n";
	}

	print "-----------------\n";

	for my $key (keys %found) {
		my $val = $found{$key};
		print "$key $val\n";
	}
}

