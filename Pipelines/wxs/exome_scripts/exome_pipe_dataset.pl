################################################
#File Name: pipe_0112.pl
#Author: C.J. Liu
#Mail: samliu@hust.edu.cn
#Created Time: Mon 12 Jan 2015 08:13:58 PM CST
################################################

#!/usr/bin/perl -w
use strict;
use warnings;
use Getopt::Long;
use File::Basename;

my %opts;
GetOptions(\%opts, "i=s","o=s", "q=s", "l=s", "c=s", "r=s","h");

my $usage=<<USAGE;
Version Description:
	This file is integrated script, input input data dir, and outdir, detailed script in exome_pipeline_1.pl;

Usage:
	perl [option] file
	options:
	-i		directory contains all sample datasets;
	-o		directory you result repo;
	-q		quality, default 1.8+
	-l		length of reads, default 100
	-c		chip you choose, default agilentv5
	-r		reference assembly, default hg19
	-h		help

Example:
	perl script.pl -i indir -o outdir
USAGE



if(defined $opts{'h'}){print $usage; exit 1;}
if(!defined $opts{'i'}){print "ERROR:input dir requires!!\n"; print $usage; exit 1;}
if(!defined $opts{'o'}){print "ERROR:out dir requires!!\n"; print $usage; exit 1;}
if(!defined $opts{'q'}){$opts{'q'} = '1.8';}
if(!defined $opts{'l'}){$opts{'l'} = '100';}
if(!defined $opts{'c'}){$opts{'c'} = 'agilent';}
if(!defined $opts{'r'}){$opts{'r'} = 'hg19';}


my @array = `ls $opts{i}`;
foreach (@array) {
	chomp;
	my $input = $opts{'i'}.'/'.$_;
	my $output = $opts{'o'}.'/'.$_;
	
	my @sample = map {basename($_)} `ls $input/*.fastq`;
	
	chomp $sample[0];
	chomp $sample[1];

	system("perl /home/liucj/piplines/scripts/exome_pipeline_1.pl -pe1 $sample[0] -pe2 $sample[1] -indir $input -outdir $output -quality $opts{'q'} -chip $opts{'c'} -length $opts{'l'} -reference $opts{'r'}&");
}









