#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;

#Fri Feb 21 16:14:46 CST 2014
#ARTHOR: C.J.LIU
#AIM: CONVERT BAM FILE TO PILEUP

#inproved Sun Feb 23 18:17:30 CST 2014
my %opts;
GetOptions(\%opts, "b=s", "h");

my $usage = <<"USAGE";
Description:
	perl script used to get pileup file by bam file.
Usage:
	perl bam2pileup.pl [opts] file.

Options:
	-b bamfile

Example:
	perl bam2pileup.pl -b bamfile.
USAGE

if(!defined $opts{'b'} || defined $opts{'h'}){
	#print $usage;
	#exit 1;
	&usage;
}

my $bam = "$opts{b}";
my $pileup = "$bam.pileup";
my $GENOMEREF='/project/liucj/REFDATA/sortedIndex/ucsc.hg19.sorted.fasta';

system("samtools mpileup -d 500 -L 500  -f $GENOMEREF $bam > $pileup");



sub usage{
	print $usage;
	exit 1;
}

