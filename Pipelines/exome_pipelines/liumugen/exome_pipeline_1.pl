################################################
#File Name: exome_pipeline_1.pl
#Author: C.J. Liu
#Mail: samliu@hust.edu.cn
#Created Time: Fri 29 Aug 2014 06:30:09 PM CST
################################################

#!/usr/bin/perl 
use strict;
use warnings;
use Getopt::Long;
use File::Basename;

my %opts;
GetOptions(\%opts, "pe1=s", "pe2=s", "indir=s", "outdir=s", "quality=s", "chip=s", "length=s", "reference=s", "h");
my $usage = <<USAGE;
Version Description:
		This is a new pipeline for exome sequencing data analysis, difference with last version is this version using module mathod to use different version of reference data, chip version, read length, and data qulity. Over all ,this version is a integrated version.
Description:
		Exome data analysis pipeline;
Usage:
		perl [option] file
		options:
		-pe1		fastq file pair-end 1[not null]
		-pe2		fastq file pair-end 2[not null]
		-indir		directory where raw fastq data is[not null]
		-outdir		directory of all output file[not null]
		-quality	sequencing data quality, option 1.3 || 1.8 [default 1.8]
		-chip		which chip usage for capture eoxme, option illumina || agilent || roche [not null]
		-length		read length[not null]
		-reference	which genenome reference used, option hg19 || hg38 [default hg19]
		-h			help
Example:
		perl exome_pipeline_1.pl -pe1 fq_1 -pe2 fq_2 -indir dir -outdir dir -chip illumina -length 100
USAGE

my ($pe1, $pe2, $indir, $outdir, $quality, $chip, $length, $reference);

if(defined $opts{'h'}){print $usage;exit 1;}
if(!defined $opts{'pe1'}){print "-pe1 requires\n"; exit 1;}
if(!defined $opts{'pe2'}){print "-pe2 requires\n"; exit 1;}
if(!defined $opts{'indir'}){print "-indir requires\n"; exit 1;}
if(!defined $opts{'outdir'}){print "-outdir requires\n"; exit 1;}
if(!defined $opts{'quality'}){$quality = "1.8";}else{$quality = $opts{'quality'};}
if(!defined $opts{'chip'}){print "-chip requires\n"; exit 1;}
if(!defined $opts{'length'}){print "-length requires\n"; exit 1;}
if(!defined $opts{'reference'}){$reference = "hg19";}else{$reference = $opts{'reference'};}
($pe1, $pe2, $indir, $outdir, $chip, $length) = ($opts{'pe1'}, $opts{'pe2'}, $opts{'indir'}, $opts{'outdir'}, $opts{'chip'}, $opts{'length'});

#print "$pe1\n$pe2\n$indir\n$outdir\n$quality\n$chip\n$length\n$reference\n";

##################
#script directory#
##################
my $script = "/home/liucj/piplines/scripts";

############
##ALIGNMENT#
############
if($quality eq "1.8"){
	system("bash $script/pipe_align1.8.sh $pe1 $pe2 $indir $outdir $reference $length $chip");
}elsif($quality eq "1.3"){
	system("bash $script/pipe_align1.3.sh $pe1 $pe2 $indir $outdir $reference $length $chip");
}

my $ALN_OUTDIR = "$outdir/align";
my $DEDUP = "$ALN_OUTDIR/$pe1.$pe2.sai.sam.dedup.bam";

####################
#GATK BEST PRACTICE#
####################
system("bash $script/pipe_bestpractice.sh $pe1 $pe2 $DEDUP $outdir $reference");
my $GATK_OUTDIR = "$outdir/GATK_call";
my $finalSNP = "$GATK_OUTDIR/$pe1.$pe2.snp.final.vcf";
my $finalINDEL = "$GATK_OUTDIR/$pe1.$pe2.indel.final.vcf";

####################
#ANNOTATION#########
####################
system("bash $script/pipe_annotation.sh $ourdir $finalSNP $finalINDEL $pe1 $pe2 $reference");















