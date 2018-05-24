#!/bin/bash

DEDUPBAM=/project/liucj/PROCESS/Sample_WGC007890/align/WGC007890.fastq.sai.sam.dedup.bam
GENOME_REF=/project/liucj/REFDATA/sortedIndex/ucsc.hg19.sorted.fasta
GATK_OUTFILE=/project/liucj/PROCESS/Sample_WGC007890/GATK_call
NEW_NAME=WGC007890.fastq.sai.sam.dedup
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
UG_OUTFILE=/project/liucj/PROCESS/Sample_WGC007890/GATK_call/UG
UG_NAME=WGC007890.UG

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
HC_OUTFILE=/project/liucj/PROCESS/Sample_WGC007890/GATK_call/HC
HC_NAME=WGC007890.HC

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
awk -f /project/liucj/PROCESS/Sample_WGC007890/scripts/pickup.awk $UG_OUTFILE/$UG_NAME.snp.filter.tmp >$UG_OUTFILE/$UG_NAME.snp.filter
awk -f /project/liucj/PROCESS/Sample_WGC007890/scripts/pickup.awk $UG_OUTFILE/$UG_NAME.indel.filter.tmp >$UG_OUTFILE/$UG_NAME.indel.filter
awk -f /project/liucj/PROCESS/Sample_WGC007890/scripts/pickup.awk $HC_OUTFILE/$HC_NAME.snp.filter.tmp >$HC_OUTFILE/$HC_NAME.snp.filter
awk -f /project/liucj/PROCESS/Sample_WGC007890/scripts/pickup.awk $HC_OUTFILE/$HC_NAME.indel.filter.tmp >$HC_OUTFILE/$HC_NAME.indel.filter

#in both methods
perl /project/liucj/PROCESS/Sample_WGC007890/scripts/inBothUG_HC.pl $UG_OUTFILE/$UG_NAME.snp.filter $HC_OUTFILE/$HC_NAME.snp.filter $GATK_OUTFILE/WGC007890.snp.final.vcf

perl /project/liucj/PROCESS/Sample_WGC007890/scripts/inBothUG_HC.pl $UG_OUTFILE/$UG_NAME.indel.filter $HC_OUTFILE/$HC_NAME.indel.filter $GATK_OUTFILE/WGC007890.indel.final.vcf


#annotation out file
ANNOVAR_OUTFILE=/project/liucj/PROCESS/Sample_WGC007890/annotation
ANNOVAR_PERL=/home/liucj/tools/annovar/
ANO_SNP_OUTFILE=/project/liucj/PROCESS/Sample_WGC007890/annotation/snp
ANO_INDEL_OUTFILE=/project/liucj/PROCESS/Sample_WGC007890/annotation/indel
HUMANDB=/project/liucj/REFDATA/humandb
#OONVERT VCF TO ANNOVAR INPUT FILE
perl $ANNOVAR_PERL/convert2annovar.pl -format vcf4 \
$GATK_OUTFILE/WGC007890.snp.final.vcf > $ANO_SNP_OUTFILE/WGC007890.snp.final.vcf.avinput

perl $ANNOVAR_PERL/convert2annovar.pl -format vcf4 \ 
$GATK_OUTFILE/WGC007890.indel.final.vcf > $ANO_INDEL_OUTFILE/WGC007890.indel.final.vcf.avinput

#annotation
perl $ANNOVAR_PERL/table_annovar.pl \
$ANO_INDEL_OUTFILE/WGC007890.indel.final.vcf.avinput \
$HUMANDB \
-buildver hg19 \
-protocol refGene,ensGene,knownGene,ccdsGene,sift,cosmic65,esp6500si_all \
-operation g,g,g,g,f,f,f \
-nastring . \
-outfile $ANO_INDEL_OUTFILE/WGC007890.indel.final.vcf.avinput

perl $ANNOVAR_PERL/table_annovar.pl \
$ANO_SNP_OUTFILE/WGC007890.snp.final.vcf.avinput \
$HUMANDB \
-buildver hg19 \
-protocol refGene,ensGene,knownGene,ccdsGene,sift,cosmic65,esp6500si_all \
-operation g,g,g,g,f,f,f \
-nastring . \
-outfile $ANO_SNP_OUTFILE/WGC007890.snp.final.vcf.avinput






