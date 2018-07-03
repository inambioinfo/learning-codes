#!/usr/bin/perl

use strict;
use warnings;
#get GMAF<0.2 records;


my $file = shift @ARGV;
my $outfile = "$file.ls_0.2";
open(GMAF, "<$file") or die("Error: cant open file: $file");
open(OUT, ">$outfile")or die("Error: cant open file:$outfile");
while(my $line = <GMAF>){
	chomp $line;
	my @array = split(/\t/, $line);
	if($array[6] eq '.') {
		print OUT "$line\n";
	}else{
		if($array[6]>0.2){
			next;
		}else{
			print OUT "$line\n";
		}
	}
}
close GMAF;
close OUT;



