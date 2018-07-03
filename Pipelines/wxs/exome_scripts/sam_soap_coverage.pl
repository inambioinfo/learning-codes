#!/usr/bin/perl


#Fri Feb 21 13:25:58 CST 2014
#AUTHOR: C.J. LIU
#AIM: CALCULATE THE COVERAGE OF BAM FILE

use strict;
use warnings;

my $samFile = shift @ARGV;
my $scripts = '/project/liucj/PROCESS/exome/liujingyu/exome_11samples_20140121/scripts';
my $genomeRef = '/project/liucj/REFDATA/sortedIndex/ucsc.hg19.sorted.fasta';
my $targetRegion = '/project/liucj/REFDATA/target_region/Roche/SeqCap_EZ_Exome_v3_primary.original.bed_64M';

system("$scripts/./soap.coverage -cvg -sam -i $samFile -refsingle $genomeRef -cdsinput $targetRegion -o $samFile.txt -cdsdetail $samFile.single -cdsplot $samFile.distribution.txt 0 10000");




