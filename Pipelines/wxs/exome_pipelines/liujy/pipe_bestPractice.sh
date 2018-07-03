#!/bin/bash

mkdir $4/GATK_call

DEDUPBAM=$3
GENOME_REF=/project/liucj/REFDATA/sortedIndex/ucsc.hg19.sorted.fasta
GATK_OUTFILE=$4/GATK_call
NEW_NAME=$1.$2.sai.sam.dedup
KNOWN_MILLS_1000G=/project/liucj/REFDATA/bundle/Mills_and_1000G_gold_standard.indels.hg19.sorted.vcf
KNOWN_1000G=/project/liucj/REFDATA/bundle/1000G_phase1.indels.hg19.sorted.vcf
DBSNP=/project/liucj/REFDATA/bundle/dbsnp_137.hg19.sorted.vcf

#CREATE INTERVAL
java -Xmx50g \
 -jar $GATKdir/GenomeAnalysisTK.jar \
 -T RealignerTargetCreator \
 -R $GENOME_REF \
 -o $GATK_OUTFILE/$NEW_NAME.intervals \
 -I $DEDUPBAM \
 -known $KNOWN_MILLS_1000G \
 -known $KNOWN_1000G
#REALIGNMENT
java -Xmx50g \
 -jar $GATKdir/GenomeAnalysisTK.jar \
 -T IndelRealigner \
 -R $GENOME_REF \
 -I $DEDUPBAM \
 -targetIntervals $GATK_OUTFILE/$NEW_NAME.intervals \
 -known $KNOWN_MILLS_1000G \
 -o $GATK_OUTFILE/$NEW_NAME.realigned.bam \
 -known $KNOWN_MILLS_1000G \
 -known $KNOWN_1000G

#RECALIBRATION
java -Xmx50g -Djava.io.tmpdir=/tmp\
 -jar $GATKdir/GenomeAnalysisTK.jar \
 -T BaseRecalibrator \
 -R $GENOME_REF \
 -I $GATK_OUTFILE/$NEW_NAME.realigned.bam \
 -knownSites $DBSNP \
 -knownSites $KNOWN_MILLS_1000G \
 -knownSites $KNOWN_1000G \
 -rf BadCigar \
 -o $GATK_OUTFILE/$NEW_NAME.realigned.bam.recal.grp 

java -Xmx50g -Djava.io.tmpdir=/tmp \
 -jar $GATKdir/GenomeAnalysisTK.jar \
 -T PrintReads \
 -R $GENOME_REF \
 -I $GATK_OUTFILE/$NEW_NAME.realigned.bam \
 -BQSR $GATK_OUTFILE/$NEW_NAME.realigned.bam.recal.grp \
 -o $GATK_OUTFILE/$NEW_NAME.realigned.recal.bam 

java -Xmx50g -Djava.io.tmpdir=/tmp/ \
 -jar $GATKdir/GenomeAnalysisTK.jar \
 -T ReduceReads \
 -R $GENOME_REF \
 -I $GATK_OUTFILE/$NEW_NAME.realigned.recal.bam \
 -o $GATK_OUTFILE/$NEW_NAME.realigned.recal.reduced.bam \

##CALLING AND FILTRATION
#UG
mkdir $GATK_OUTFILE/UG
UG_OUTFILE=$GATK_OUTFILE/UG
UG_NAME=$1.$2.UG

java -Xmx50g -Djava.io.tmp=/tmp \
 -jar $GATKdir/GenomeAnalysisTK.jar \
 -glm BOTH \
 -T UnifiedGenotyper \
 -R $GENOME_REF \
 -I $GATK_OUTFILE/$NEW_NAME.realigned.recal.reduced.bam \
 -D $DBSNP \
 -nct 10 \
 -stand_emit_conf 10 \
 -stand_call_conf 30 \
 -o $UG_OUTFILE/$UG_NAME.variants.vcf

#SNP
 java -Xmx50g -Djava.io.tmpdir=/tmp \
 -jar $GATKdir/GenomeAnalysisTK.jar \
 -R $GENOME_REF \
 -T SelectVariants \
 -V $UG_OUTFILE/$UG_NAME.variants.vcf \
 -selectType SNP \
 -o $UG_OUTFILE/$UG_NAME.snp.vcf 

java -Xmx50g -Djava.io.tmpdir=/tmp \
 -jar $GATKdir/GenomeAnalysisTK.jar \
 -R $GENOME_REF \
 -T VariantFiltration \
 -V $UG_OUTFILE/$UG_NAME.snp.vcf \
 --clusterWindowSize 10 \
 --clusterSize 3 \
 --filterExpression \
 "DP < 8 || QD < 2.0 || FS > 60.0 || MQ < 40.0 || HaplotypeScore > 13.0 || MappingQualityRankSum < -12.5 || ReadPosRankSum < -8.0" \
 --filterName "GATK_snp_filter" \
 -o $UG_OUTFILE/$UG_NAME.snp.filter.tmp

#INDEL
java -Xmx50g -Djava.io.tmpdir=/tmp \
 -jar $GATKdir/GenomeAnalysisTK.jar \
 -R $GENOME_REF \
 -T SelectVariants \
 -V $UG_OUTFILE/$UG_NAME.variants.vcf \
 -selectType INDEL \
 -o $UG_OUTFILE/$UG_NAME.indel.vcf

java -Xmx50g -Djava.io.tmpdir=/tmp \
 -jar $GATKdir/GenomeAnalysisTK.jar \
 -R $GENOME_REF \
 -T VariantFiltration \
 -V $UG_OUTFILE/$UG_NAME.indel.vcf \
 --clusterWindowSize 10 \
 --clusterSize 3 \
 --filterExpression \
"DP < 8 || QD < 3.0 || FS > 200.0 || ReadPosRankSum < -20.0" \
 --filterName "GATK_indel_filter" \
 -o $UG_OUTFILE/$UG_NAME.indel.filter.tmp

##HC
mkdir $GATK_OUTFILE/HC
HC_OUTFILE=$GATK_OUTFILE/HC
HC_NAME=$1.$2.HC

java -Xmx50g -Djava.io.tmpdir=/tmp \
 -jar $GATKdir/GenomeAnalysisTK.jar \
 -T HaplotypeCaller \
 -R $GENOME_REF \
 --genotyping_mode DISCOVERY \
 -nct 10 \
 --dbsnp $DBSNP \
 -stand_emit_conf 10 \
 -stand_call_conf 30 \
 -I $GATK_OUTFILE/$NEW_NAME.realigned.recal.reduced.bam \
 -o $HC_OUTFILE/$HC_NAME.variants.vcf

#SNP
java -Xmx50g -Djava.io.tmpdir=/tmp \
 -jar $GATKdir/GenomeAnalysisTK.jar \
 -R $GENOME_REF \
 -T SelectVariants \
 -V $HC_OUTFILE/$HC_NAME.variants.vcf \
 -selectType SNP \
 -o $HC_OUTFILE/$HC_NAME.snp.vcf

java -Xmx50g -Djava.io.tmpdir=/tmp \
 -jar $GATKdir/GenomeAnalysisTK.jar \
 -R $GENOME_REF \
 -T VariantFiltration \
 -V $HC_OUTFILE/$HC_NAME.snp.vcf \
 --clusterWindowSize 10 \
 --clusterSize 3 \
 --filterExpression \
 "DP < 8 || QD < 2.0 || FS > 60.0 || MQ < 40.0 || HaplotypeScore > 13.0 || MappingQualityRankSum < -12.5 || ReadPosRankSum < -8.0" \
 --filterName "GATK_snp_filter" \
 -o $HC_OUTFILE/$HC_NAME.snp.filter.tmp

#INDEL
java -Xmx50g -Djava.io.tmpdir=/tmp \
 -jar $GATKdir/GenomeAnalysisTK.jar \
 -R $GENOME_REF \
 -T SelectVariants \
 -V $HC_OUTFILE/$HC_NAME.variants.vcf \
 -selectType INDEL \
 -o $HC_OUTFILE/$HC_NAME.indel.vcf

java -Xmx50g -Djava.io.tmpdir=/tmp \
 -jar $GATKdir/GenomeAnalysisTK.jar \
 -R $GENOME_REF \
 -T VariantFiltration \
 -V $HC_OUTFILE/$HC_NAME.indel.vcf \
 --clusterWindowSize 10 \
 --clusterSize 3 \
 --filterExpression \
 "DP < 8 || QD < 3.0 || FS > 200.0 || ReadPosRankSum < -20.0" \
 --filterName "GATK_indel_filter" \
 -o $HC_OUTFILE/$HC_NAME.indel.filter.tmp

#filter 
awk -f /home/liucj/piplines/piplines/liujjy/pipe_pickup.awk $UG_OUTFILE/$UG_NAME.snp.filter.tmp >$UG_OUTFILE/$UG_NAME.snp.filter
awk -f /home/liucj/piplines/piplines/liujjy/pipe_pickup.awk $UG_OUTFILE/$UG_NAME.indel.filter.tmp >$UG_OUTFILE/$UG_NAME.indel.filter
awk -f /home/liucj/piplines/piplines/liujjy/pipe_pickup.awk $HC_OUTFILE/$HC_NAME.snp.filter.tmp >$HC_OUTFILE/$HC_NAME.snp.filter
awk -f /home/liucj/piplines/piplines/liujjy/pipe_pickup.awk $HC_OUTFILE/$HC_NAME.indel.filter.tmp >$HC_OUTFILE/$HC_NAME.indel.filter

#in both methods
perl /home/liucj/piplines/piplines/liujjy/pipe_inBothUG_HC.pl $UG_OUTFILE/$UG_NAME.snp.filter $HC_OUTFILE/$HC_NAME.snp.filter $GATK_OUTFILE/$1.$2.snp.final.vcf

perl /home/liucj/piplines/piplines/liujjy/pipe_inBothUG_HC.pl $UG_OUTFILE/$UG_NAME.indel.filter $HC_OUTFILE/$HC_NAME.indel.filter $GATK_OUTFILE/$1.$2.indel.final.vcf


