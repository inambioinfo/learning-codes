#!/usr/bin/perl
use strict;
use warnings;
#use Statistics::R;
use Getopt::Long;
use File::Basename;
#Fri Feb 21 18:35:18 CST 2014
#AUTHOR: C.J. LIU
#AIM: SUMMARY OF THE DATA QUALITY;

#Mod Wed Mar 12 09:14:18 CST 2014
#this script can work but not complete
#this mod goal is about: 
#1 speed up,it's slow because of process of producing pileup file 
#2 the lack of destribution and statistics pics 
#3. flexibility, now the script is only served for Roche chip,and read length is fixed 100bp;


my $chipCap = '/project/liucj/REFDATA/target_region/Roche/SeqCap_EZ_Exome_v3_primary.original.bed_64M'; #chip beta
my $readLength; 								#read length of fastq file 
my $targetRegionIllumina = "63564965"; 						#total bps in NimbleGem chip

my %opts;
GetOptions(\%opts, "pe1=s", "pe2=s", "o=s", "outdir=s", "l=s", "h");

if(defined $opts{'l'}){
	$readLength = $opts{'l'};
}else{
	$readLength = 100;
}



my $usage = << "USAGE";
Description:
	perl script used to filter low quality short reads, remove polyA and trim 3'5' adapter
Usage:
	perl summary.pl [option] file
	options:
	-pe1 seq fastq data of pair-end sequencing
	-pe2 seq fastq data of pair-end sequencing 
	-o output file
	-outdir output directory
	-l readlength, default length is 100
	-h help 
Example:
	perl summary.pl -pe1 rawData_pe1.fq -pe2 rawData_pe2.fq -o outputFile.xls -outdir directory 
USAGE

if(
	!(
	defined $opts{pe1} and
	defined $opts{pe2} and
	defined $opts{o}   and
	defined $opts{outdir}
	)||(
	defined $opts{h}
	)
){
	print $usage;
	exit 1;
	}
my $seq1 = basename($opts{pe1});
my $seq2 = basename($opts{pe2});
my $outdir = $opts{outdir};
my $sam       = "$seq1.$seq2.sai.sam";	#sam fil
#my $samSingle = "$sam.single";		#sam.single containing numble in very covered pos provided by soap.coverage,
my $samBam    = "$sam.bam";		#no dedup bam file
my $bamPileup  = "$outdir/$sam.bam.pileup";	#to compute raw data	
my $DedupBam  = "$sam.dedup.bam";	#dedup bam file
my $pileup    = "$outdir/$DedupBam.pileup";	#pileup file, the output file of dedup.bam
my $sample    = "$seq1.$seq2";	#the Name of whole quality
my $outfile   = "$outdir/$opts{o}";		#the summary output file
#my $outfile2  = "$outfile.depth_distribution";	#

##---caltulate raw reads & total sequenced bps & bps.M---##
my $rawRead = `wc -l $opts{pe1} | cut -d " " -f 1`;	chomp $rawRead;		$rawRead = $rawRead / 2;
my $total_bps = $rawRead * $readLength;
my $total_bps_M = sprintf("%d", $total_bps / 1000000);

##---       ---##
##---store the key and value in hash ---##
my %hashBeta;
open(CHIP, "$chipCap") or die("Error: cant open file :$chipCap\n");;
while(my $line = <CHIP>){
	chomp $line;
	my @array = split(/\t/, $line);
	my $chr   = $array[0];
	my $start = $array[1] + 1;
	my $end   = $array[2];
	my $value = $array[3];
	foreach my $key ($start..$end){
		$hashBeta{$chr."_".$key} = $value;
	}
}
close CHIP;
##---         ---##
my $totalSeqPos         = 0;	my $totalSeqPileup       = 0;
my $totalTargetPos      = 0;	my $totalTargetPileup    = 0;
my @distribute		= ();	my $totalTargetPos20     = 0;
my $totalTargetPos10    = 0;	my $totalTargetPos4      = 0;
my $totalOutTargetPos   = 0;	my $totalOutTargetPileup = 0;
my $totalOutTargetPos20 = 0;	my $totalOutTargetPos10  = 0;
my $totalOutTargetPos4  = 0;

open(PILEUP, "$pileup") or die("Error: cant open file: $pileup\n");
while(my $line = <PILEUP>){
	chomp $line;
	my ($chr, $pos, $num) = (split(/\t/, $line))[0, 1, 3];
	my $key = $chr."_".$pos;
	$totalSeqPos++;
	$totalSeqPileup += $num;
	
	if(exists $hashBeta{$key}){
		$totalTargetPos++;
		$totalTargetPileup += $num;
		if(!defined $distribute[$num]){$distribute[$num] = 0;}
		$distribute[$num] = $distribute[$num] + $num;
		if($num >= 20){
			$totalTargetPos20++;
		}
		if($num >= 10){
			$totalTargetPos10++;
		}
		if($num >= 4){
			$totalTargetPos4++;
		}
	}else{
		$totalOutTargetPos++;
		$totalOutTargetPileup += $num;
		if($num >= 20){
			$totalOutTargetPos20++;
		}
		if($num >= 10){
                        $totalOutTargetPos10++;
                }
		if($num >= 4){
                        $totalOutTargetPos4++;
                }	
	}
}
close PILEUP;

##--- summary ---##
my $totalSeqPileupM          = sprintf("%d", 	$totalSeqPileup 	/ 1000000			);
my $totalTargetPileupM       = sprintf("%d", 	$totalTargetPileup 	/ 1000000			);
my $totalOutTargetPileupM    = sprintf("%d", 	$totalOutTargetPileup 	/ 1000000			);
my $seqDepth                 = sprintf("%0.2f", $totalSeqPileup 	/ $totalSeqPos			);
my $targetDepth              = sprintf("%0.2f", $totalTargetPileup 	/ $targetRegionIllumina		);
my $targetCoverage           = sprintf("%0.2f", $totalTargetPos 	/ $targetRegionIllumina * 100	);
my $target4                  = sprintf("%0.2f", $totalTargetPos4 	/ $targetRegionIllumina * 100	);
my $target10                 = sprintf("%0.2f", $totalTargetPos10 	/ $targetRegionIllumina * 100	);
my $target20                 = sprintf("%0.2f", $totalTargetPos20 	/ $targetRegionIllumina * 100	);
my $outTargetDepth	     = sprintf("%0.2f", $totalOutTargetPileup   / $totalOutTargetPos		);	
my $outTarget4               = sprintf("%0.2f", $totalOutTargetPos4 	/ $totalOutTargetPos * 100	);
my $outTarget10              = sprintf("%0.2f", $totalOutTargetPos10 	/ $totalOutTargetPos * 100	);
my $outTarget20              = sprintf("%0.2f", $totalOutTargetPos20 	/ $totalOutTargetPos * 100	);
my $dupCount 		     = `samtools view $outdir/$samBam   -c | cut -f 1`;		chomp $dupCount;
my $DedupCount 		     = `samtools view $outdir/$DedupBam -c | cut -f 1`;		chomp $DedupCount;
my $dupRate 		     = sprintf("%0.2f", ($dupCount - $DedupCount) / $dupCount * 100		);
my ($rawMappedBase, $rawDepth, $rawCoverage) = &rawDepth($bamPileup);

open(OUT, ">$outfile") or die("Error: cant open file :$outfile\n");
print OUT <<TABLE;
Exome Capture Statistics\t $sample
Target region (bp)\t $targetRegionIllumina
Number of raw sequenced base (Mb)\t $total_bps_M
Number of raw reads\t $rawRead
Average read length (bp)\t $readLength
Raw data mapped to target region yield (Mb)\t $rawMappedBase
Raw depth of target region\t $rawDepth
Fraction of coverage of Raw data in target region (%)\t $rawCoverage
PCR duplication rate (%)\t $dupRate
Number of processed data mapped to genome  (Mb)\t $totalSeqPileupM
Mean depth of base mapped to genome\t $seqDepth
Number of base mapped to target region (Mb)\t $totalTargetPileupM
Mean depth of base mapped to target region\t $targetDepth
Fraction of coverage of target region (%)\t $targetCoverage
Fraction of coverage of sequencing depth >= 4x  in target region (%)\t $target4
Fraction of coverage of sequencing depth >= 10x in target region (%)\t $target10
Fraction of coverage of sequencing depth >= 20x in target region (%)\t $target20
Number of base mapped to flanking region (Mb)\t $totalOutTargetPileupM
Mean depth of base mapped to flanking region\t $outTargetDepth
Fraction of coverage of sequencing depth >= 4x  in flanking region (%)\t $outTarget4 
Fraction of coverage of sequencing depth >= 10x in flanking region (%)\t $outTarget10
Fraction of coverage of sequencing depth >= 20x in flanking region (%)\t $outTarget20
TABLE
close OUT;

##---mapped base to caltulate target base & target mean depth ---##
sub rawDepth{
	my $file = shift;
	my $coveredSum      = 0;
	my $baseIntargetSum = 0;
	open(SINGLE, "$file") or die("Error: cant open file $file \n");
	while(my $line = <SINGLE>){
		chomp $line;

		#next unless($line =~ /^>/);
		my ($chr, $pos, $num) = (split(/\t/, $line))[0, 1, 3];
		my $key = $chr."_".$pos;
		if(exists $hashBeta{$key}){
			$coveredSum ++;
			$baseIntargetSum += $num;
		}
		#$coveredSum += $covered;
		
		#$baseIntargetSum += $mean * $target;
	}
	my $RocheMeanDepth = sprintf("%0.2f", $baseIntargetSum / $targetRegionIllumina);
	my $mappedBase = sprintf("%d", $baseIntargetSum / 1000000);
	my $coverage = sprintf("%0.2f", $coveredSum/$targetRegionIllumina * 100);
	return ($mappedBase, $RocheMeanDepth, $coverage);
}







