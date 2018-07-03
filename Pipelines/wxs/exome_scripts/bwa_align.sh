#!/bin/bash

BWA_INDEX=/project/liucj/REFDATA/sortedIndex
SAMPLE_FILE=/project/liucj/SAMPLE/Sample_WGC007890
SAMPLE1=WGC007890_combined_filtered_R1.fastq
SAMPLE2=WGC007890_combined_filtered_R2.fastq
ALN_OUTFILE=/project/liucj/PROCESS/Sample_WGC007890/align
SAMFLIE=WGC007890.fastq
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
 -r "@RG\tID:Sample_WGC007890\tLB:Sample_WGC007890\tSM:Sample_WGC007890\tPL:ILLUMINA" \
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
