#!/bin/bash
mkdir $3/align
SCRIPT_DIR=/home/liucj/piplines/piplines/liujjy
BWA_INDEX=/project/liucj/REFDATA/sortedIndex
SAMPLE_FILE=$4
SAMPLE1=$1
SAMPLE2=$2
ALN_OUTFILE=$3/align
SAMFILE=$1.$2
#ALINMENT
bwa aln -q 15 -l 35 -k 2 -t 10 \
 -f $ALN_OUTFILE/$SAMPLE1.sai \
 $BWA_INDEX/ucsc.hg19.sorted.fasta  \
 $SAMPLE_FILE/$SAMPLE1 

bwa aln -q 15 -l 35 -k 2 -t 10 \
 -f $ALN_OUTFILE/$SAMPLE2.sai \
 $BWA_INDEX/ucsc.hg19.sorted.fasta  \
 $SAMPLE_FILE/$SAMPLE2

bwa sampe -f $ALN_OUTFILE/$SAMFILE.sai.sam  \
 -r "@RG	ID:$SAMFILE	LB:$SAMFILE	SM:$SAMFILE	PL:ILLUMINA" \
 $BWA_INDEX/ucsc.hg19.sorted.fasta \
 $ALN_OUTFILE/$SAMPLE1.sai \
 $ALN_OUTFILE/$SAMPLE2.sai \
 $SAMPLE_FILE/$SAMPLE1 \
 $SAMPLE_FILE/$SAMPLE2 

#SORT
java -Xmx50g -Djava.io.tmpdir=/tmp \
 -jar $Pdir/SortSam.jar \
 SO=coordinate \
 INPUT=$ALN_OUTFILE/$SAMFILE.sai.sam \
 OUTPUT=$ALN_OUTFILE/$SAMFILE.sai.sam.bam \
 VALIDATION_STRINGENCY=LENIENT \
 CREATE_INDEX=true 

#CONVERT BAM TO BAM.PILERUP 
perl $SCRIPT_DIR/bam2pileup.pl -b $ALN_OUTFILE/$SAMFILE.sai.sam.bam

#MARK DUPLICATES
java -Xmx50g -Djava.io.tmpdir=/tmp \
 -jar $Pdir/MarkDuplicates.jar \
 INPUT=$ALN_OUTFILE/$SAMFILE.sai.sam.bam \
 OUTPUT=$ALN_OUTFILE/$SAMFILE.sai.sam.dedup.bam \
 METRICS_FILE=$ALN_OUTFILE/mark.metrics \
 MAX_RECORDS_IN_RAM=5000000 \
 ASSUME_SORTED=true \
 VALIDATION_STRINGENCY=LENIENT \
 REMOVE_DUPLICATES=true \
 CREATE_INDEX=true

#CONVERT DEDUP BAM TO PILEUP
perl $SCRIPT_DIR/bam2pileup.pl -b $ALN_OUTFILE/$SAMFILE.sai.sam.dedup.bam

#COMPUTE DATA STATISTICS
perl $SCRIPT_DIR/summary_Illumina_Read_Length_98.pl_2.0 -pe1 $SAMPLE_FILE/$SAMPLE1 -pe2 $SAMPLE_FILE/$SAMPLE2 -o $SAMFILE.xls -outdir $ALN_OUTFILE


