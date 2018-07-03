################################################
#File Name: dbsnp.GMAF.test.pl
#Author: C.J. Liu
#Mail: samliu@hust.edu.cn
#Created Time: Thu 04 Sep 2014 04:37:42 PM CST
################################################

#!/usr/bin/perl -w
use strict;
use warnings;
use Getopt::Long;
use File::Basename;

#AIM:
#To test GATK UG & HC dbsnp annotation.
#i
my %opts;
GetOptions(\%opts, "i=s", "h");
my $usage = <<USAGE;
Description:
	To test GATK UG & HC dbsnp annotation;
Usage:
	perl proram.pl [option] file
Options:
	i	input file
	h	for help;
USAGE
if(!defined $opts{'i'} or defined $opts{'h'}){
	print $usage;
	exit 1;
}


my $dbsnp = "/project/liucj/REFDATA/bundle/dbsnp_137.hg19.sorted.vcf.GMAF";
print $dbsnp."\n";
my %dbsnp;
open(DBSNP,"<$dbsnp") or die("cant open file:$dbsnp\n;");
while(my $line = <DBSNP>){
	chomp $line;
	if($line =~ /^#/){next;}
	my @array = split("\t", $line);
	my $key = "$array[0]_$array[1]_$array[3]_$array[4]";
	$dbsnp{$key} = $array[2];
}
close DBSNP;

open(IN,"<$opts{'i'}") or die("Error: cant open file:$opts{'i'}");
while(my $line = <IN>){
	chomp $line;
	if($line =~ /^#/){next;}
	my @array = split("\t", $line);
	my $key = "$array[0]_$array[1]_$array[3]_$array[4]";
	if(defined $dbsnp{$key}){
		my @new = split("_", $key);
		my $record = join("\t", @new, $dbsnp{$key}, $array[2]);
		print $record."\n";
	}
	
}
close IN;






