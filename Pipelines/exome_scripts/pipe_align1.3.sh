#########################################################################
# File Name: pipe_align.sh
# Author: C.J. Liu
# Mail: samliu@hust.edu.cn
# Created Time: Sat 30 Aug 2014 02:51:36 PM CST
#########################################################################

#########################################################################
#four input parameters
#$1 $2 coordinate $pe1 and $pe2
#$3 $4 coordinate $indir and $outdir
#$5 $reference genome reference 
#$6 $length readlength
#$7 $chip chip usage
#########################################################################

#!/bin/bash
mkdir -p $4/align
SAMPLE1=$1
SAMPLE2=$2
INDIR=$3
OUTDIR=$4
ALN_OUTDIR=$OUTDIR/align
SAM=$SAMPLE1.$SAMPLE2
SCRIPT=/home/liucj/piplines/scripts


###########################
#chose genome reference
###########################
case "$5" in
	"hg19")	INDEX=/project/liucj/REFDATA/sortedIndex/ucsc.hg19.sorted.fasta;;
	"hg38") echo "not build"; exit 1;;
		*)  echo "reference must be required";;
esac
		
############################
#chose chip
############################



############################
##ALIGNMENT
############################
bwa aln -q 15 -l 35 -k 2 -t 10 -I \
	-f $ALN_OUTDIR/$SAMPLE1.sai \
	$INDEX \
	$INDIR/$SAMPLE1

bwa aln -q 15 -l 35 -k 2 -t 10 -I \
	-f $ALN_OUTDIR/$SAMPLE2.sai \
	$INDEX \
	$INDIR/$SAMPLE2

bwa sampe -f $ALN_OUTDIR/$SAM.sai.sam \
	-r "@RG	ID:$SAM	LB:$SAM	SM:$SAM	PL:ILLUMINA" \
	$INDEX \
	$ALN_OUTDIR/$SAMPLE1.sai \
	$ALN_OUTDIR/$SAMPLE2.sai \
	$INDIR/$SAMPLE1 \
	$INDIR/$SAMPLE2 

########################
#SORT
########################
java -Xmx50g -Djava.io.tmpdir=/tmp \
	-jar $Pdir/SortSam.jar \
	SO=coordinate \
	INPUT=$ALN_OUTDIR/$SAM.sai.sam \
	OUTPUT=$ALN_OUTDIR/$SAM.sai.sam.bam \
	VALIDATION_STRINGENCY=LENIENT \
	CREATE_INDEX=true

############################
#CONVERT BAM TO BAM.PILEUP
############################
perl $SCRIPT/bam2pileup.pl -b $ALN_OUTDIR/$SAM.sai.sam.bam

#####################################
#MARK DUPLICATES
#####################################
java -Xmx50g -Djava.io.tmpdir=/tmp \
	-jar $Pdir/MarkDuplicates.jar \
	INPUT=$ALN_OUTDIR/$SAM.sai.sam.bam \
	OUTPUT=$ALN_OUTDIR/$SAM.sai.sam.dedup.bam \
	METRICS_FILE=$ALN_OUTDIR/mark.metrics \
	MAX_RECORDS_IN_RAM=5000000 \
	ASSUME_SORTED=true \
	VALIDATION_STRINGENCY=LENIENT \
	REMOVE_DUPLICATES=true \
	CREATE_INDEX=true

######################################
#CONVERT DEDUP BAM TO PILEUP
######################################
perl $SCRIPT/bam2pileup.pl -b $ALN_OUTDIR/$SAM.sai.sam.dedup.bam

######################################
#COMPUTATIONAL STATISTICS
######################################
CHIP=$7
LENGTH=$6
case "$CHIP" in
	"illumina") perl $SCRIPT/summary_illumina.pl -pe1 $INDIR/$SAMPLE1 -pe2 $INDIR/$SAMPLE2 -l $LENGTH -o $SAM.xls -outdir $ALN_OUTDIR;;
	"roche") perl $SCRIPT/summary_roche.pl -pe1 $INDIR/$SAMPLE1 -pe2 $INDIR/$SAMPLE2 -l $LENGTH -o $SAM.xls -outdir $ALN_OUTDIR;;
	"agilent") perl $SCRIPT/summary_agilent.pl -pe1 $INDIR/$SAMPLE1 -pe2 $INDIR/$SAMPLE2 -l $LENGTH -o $SAM.xls -outdir $ALN_OUTDIR;;
		*)	echo "choose chip illumina, roche or agilent"; exit 1;;
esac









