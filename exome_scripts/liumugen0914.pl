################################################
#File Name: liumugen0914.pl
#Author: C.J. Liu
#Mail: samliu@hust.edu.cn
#Created Time: Sun 14 Sep 2014 04:38:40 PM CST
################################################

#!/usr/bin/perl -w
use strict;
use warnings;
use Getopt::Long;
use File::Basename;
use Switch;

while(@ARGV){
	my $file = shift @ARGV;
	my $out = $file.".out";
	open IN, "<$file" or die "error: cant open file: $file\t$!\n";
	open OUT, ">$out" or die "error: cant open file: $out\t$!\n";
	while(<IN>){
		chomp;
		my @input = (split "\t")[0, 1];
		&filter(@input, $_);		
	}
	close IN;
	close OUT;
}
sub filter{
	my ($chr, $pos, $line) = @_;

	switch($chr){
		case "chr1"		{print OUT $line."\n" if $pos > 63954918 or $pos < 76070355;}
		case "chr12"	{print OUT $line."\n" if $pos > 106456450 or $pos < 114113269;
						print OUT $line."\n" if $pos > 100518849 or $pos < 107722035;
						print OUT $line."\n" if $pos > 105997448 or $pos < 124063122;
						}
		case "chr15"	{print OUT $line."\n" if $pos > 77121010 or $pos < 85999727;}
		case "chr16"	{print OUT $line."\n" if $pos > 81471556 or $pos < 86585279;}
		case "chr18"	{print OUT $line."\n" if $pos > 10000 or $pos < 5871431;}
	}
}


