#!/usr/bin/perl
use strict;

#Tue Feb 18 20:14:10 CST 2014
#print first input
die("ERROR: the number of input files is not 3") if(@ARGV != 3);
my($infile1, $infile2, $outfile) = @ARGV;
open(IN1, "<$infile1") or die("Error: cant open file ");
open(IN2, "<$infile2") or die("Error: cant open file");
open(OUT, ">$outfile") or die("Error: cant open file");
my %list;
while(my $line = <IN2>){
	chomp $line;
        my @array = split(/\t/, $line);
        my $chr = shift @array;
        my $start = shift @array;
	my $end = shift @array;
	my $ref = shift @array;
	my $alt = shift @array;
        my $tmp = $chr.$start.$end.$ref.$alt;
	 $list{$tmp} = $line;
}

while(my $line = <IN1>){
	chomp $line;
        my @array = split(/\t/, $line);
	my $key = $array[0].$array[1].$array[2].$array[3].$array[4];
	if(defined $list{$key}){
		print OUT $list{$key}."\n";
	}
}
close OUT;
close IN1;
close IN2;




