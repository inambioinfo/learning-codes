#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;

#Wed Mar 12 15:26:22 CST 2014
#AIM:FUSE GMAF INFORMATION INTO ANNO TXT
my %opts;
GetOptions(\%opts, "i=s", "h");
my $usage = <<USAGE;
Description:
	fuse GMAF information from dbsnp into annotation text;
Usage:
	perl GMAF.pl [option] file
	options:
	-i 	input annotated file
	-h 	help
Example:
	perl GMAF.pl -i txt.qual
USAGE

if(!defined $opts{'i'} || defined $opts{'h'}){
	print $usage;
	exit 1;
}

my $dbsnp = "/project/liucj/REFDATA/bundle/dbsnp_137.hg19.sorted.vcf.GMAF";
my %hashDbsnp;
open(DBSNP, "$dbsnp") or die ("Error: cant open file:$dbsnp");;
while(my $line = <DBSNP>){
	chomp $line;
	my @array = split(/\t/, $line);
	my $key = $array[2];
	$hashDbsnp{$key} = "$array[2]\t$array[5]\t$array[6]\t$array[7]";
}
close DBSNP;

my $infile = "$opts{'i'}";
my $outfile = "$infile.GMAF";
open(IN, "$infile") or die("Error:cant open file: $infile\n");
open(OUT, ">$outfile") or die("Error:cant open file: $outfile\n");
while(my $line = <IN>){
	my @array = split(/\t/, $line);
	if(exists $hashDbsnp{$array[5]}){
		 $array[5] = $hashDbsnp{$array[5]};
	}else{$array[5] = ".\t.\t.\t.";}
	my $outline = join("\t", @array);
	print OUT "$outline";
}
close IN;
close OUT;

