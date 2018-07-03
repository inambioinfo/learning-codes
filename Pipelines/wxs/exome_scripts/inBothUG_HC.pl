#!/usr/bin/perl

#C.J. Liu 2013-11-25
#pick up the same records in both UG and HC outputs

die("Error,input nubmer of files is not right!")if(@ARGV!=3);
($infile1,$infile2,$outfile)=@ARGV;

#infile1 is the HC
#infile2 is the UG
#output is the records in both

open(IN1,"<$infile1") || die("cant open file");
open(OUT,">$outfile") || die("cant open file");

while(<IN1>){
	chomp;
	my @array1 = split /\t/,$_;
	open(IN2,"<$infile2") || die("cant open file");
	while(<IN2>){
		chomp;
		my @array2 = split /\t/,$_;
		if(($array1[0] eq $array2[0])&&($array1[1]==$array2[1])){
			print  OUT $_."\n";}
	}
}





