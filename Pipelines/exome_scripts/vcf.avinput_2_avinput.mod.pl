#!/usr/bin/perl

#Tue Feb 18 15:04:55 CST 2014
use strict;
my $infile = shift @ARGV;
my $outfile = "$infile.mod";
open(IN, "<$infile") or die("Error: cant open file");
open(OUT,">$outfile") or die("Error: cant open file");

while(my $line = <IN>){
	chomp $line;
	my @array = split(/\t/, $line);
	my $ID = $array[7]; my $QUAL = $array[10];
	my $DP; my $QD; my $MQ; my $GT; my $AD;
	if($line =~ /;DP=(.*?);/){
		$DP = $1;
	#	print $DP."\n";
	}
	if($line =~ /;QD=(.*?)[\t;]/){
		$QD = $1;
	#	print $QD."\n";
	}
	if($line =~ /;MQ=(.*?);/){
		$MQ = $1;
	#	print $MQ."\n";
	}
	if($line =~ /\tGT:AD:DP:GQ:PL\t(.*?):(.*?):/){
		$GT = $1;
		$AD = $2;
	#	print "$1\t$2\n";
	}
	print  OUT "$array[0]\t$array[1]\t$ID\t$QUAL\t$DP\t$QD\t$MQ\t$GT\t$AD\n"
}



