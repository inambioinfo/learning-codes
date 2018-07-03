#!/usr/bin/perl

#Wed Jan 15 16:56:47 CST 2014
#AUTHOR: C.J. LIU
#AIM: CONVERT GFF FORMAT TO ANNOTATION FORMAT REQUEST

use strict;
die("ERRORS!! THE NUMBER OF FILES IS NOT 2") if @ARGV != 2;
(my $inputFile, my $outFile) = @ARGV;

open(IN, "<$inputFile") || die("cant open file");
open(OUT, ">$outFile") || die("cant open file");

print OUT "Chr\tStart\tEnd\tID\tRef\tAlt\tFunction\tGeneinfo\n";
while(my $line = <IN>){
	chomp $line;
	my @array = split(/\t/, $line);
	my $info = $array[-1];
	my $ID; my $Ref; my $Alt; my $Func;
	
	if($info =~ /ID=(.*?);/){$ID = $1;}
	if($info =~ /ref=(.*?);/){$Ref = $1;}
	if($info =~ /alleles=(.*?);/){$Alt = $1;}
	if($info =~ /function=(.*?);/){$Func = $1;}
	
	my $result = "$array[0]\t$array[3]\t$array[4]\t$ID\t$Ref\t$Alt\t$Func\t$info\n";
	print OUT $result;
}
close IN;
close OUT;



