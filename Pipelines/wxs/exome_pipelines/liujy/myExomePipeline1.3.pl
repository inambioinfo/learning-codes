#!/usr/bin/perl
=pod
Thu Dec 26 13:25:00 CST 2013
Author: C. J. Liu
description: for exome pipeline
	alignment, call snp&indel,annotation 
=cut

use strict;
use 5.010;
#################################################
#file1, file2, input directory, output directory;
#################################################

die("ERROR::the number of files is not right") if(@ARGV != 4);
my ($samplePE1, $samplePE2, $inputDir, $outputDir) = @ARGV ;

###################################################
###ALIGNMENT###
###################################################
###################################################
###SORT###REMOVE DUPLICATES###
###################################################
system(" bash pipe_align1.3.sh $samplePE1 $samplePE2 $outputDir $inputDir ");
my $ALN_OUTFILE = "$outputDir/align";
my $DEDUP = "$ALN_OUTFILE/$samplePE1.$samplePE2.sai.sam.dedup.bam";

##################################################
###GATK BEST PRACTICE###
##################################################
system("
bash pipe_bestPractice.sh  $samplePE1 $samplePE2 $DEDUP $outputDir
");
my $GATK_OUTFILE = "$outputDir/GATK_call";
my $finalSNP = "$GATK_OUTFILE/$samplePE1.$samplePE2.snp.final.vcf";
my $finalINDEL = "$GATK_OUTFILE/$samplePE1.$samplePE2.indel.final.vcf";


#################################################
###ANNOTATION##
#################################################
system("
bash pipe_annotation.sh $outputDir $finalSNP $finalINDEL $samplePE1 $samplePE2
");


