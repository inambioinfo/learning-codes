################################################
#File Name: debug.rs.pl
#Author: C.J. Liu
#Mail: samliu@hust.edu.cn
#Created Time: Wed 03 Sep 2014 06:19:29 PM CST
################################################

#!/usr/bin/perl -w
use strict;
use warnings;
use Getopt::Long;
use File::Basename;


my %opts;
GetOptions(\%opts, "in1=s", "in2=s", "h");
my $usage=<<USAGE;
Description:
	To find bug by check vcf output file	
Usage:
	perl [option] file
	options:
	-in1		input vcf file
	-in2		input vcf file
	-h			help
USAGE

if(!defined ($opts{'in1'} && $opts{'in2'}) || defined $opts{'h'}){
	print $usage;
	exit 1;
}


my $file1 = $opts{'in1'};
my $file2 = $opts{'in2'};

my $out = $file1.$file2;
open(FILE1,"<$file1") or die("Error: cant open file: $file1\n");
my %hash1;

while( my $line = <FILE1>){
	chomp $line;
	my @array = split("\t", $line);
	my $key = "$array[0]_$array[1]_$array[2]_$array[3]_$array[4]";
	my $value = $array[5];
	$hash1{$key} = $value;
}
close FILE1;

open(FILE2,"<$file2") or die("Error: cant open file: $file2\n");

my %hash2;
while(my $line = <FILE2>){
	chomp $line;
	my @array = split("\t", $line);
	my $key = "$array[0]_$array[1]_$array[2]_$array[3]_$array[4]";
	my $value = $array[5];
	$hash2{$key} = $value;
}

close FILE2;

foreach my $key (keys %hash2){
	if(defined $hash1{$key}){
		my @array = split("_", $key);
		if($hash1{$key} ne $hash2{$key}){
			my $line = join("\t", @array, $hash1{$key}, $hash2{$key});
			print $line."\n";
		}
	}
}




















