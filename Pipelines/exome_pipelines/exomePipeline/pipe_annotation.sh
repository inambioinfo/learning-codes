#!/bin/bash


#annotation out file
mkdir $1/annotation
ANNOVAR_OUTFILE=$1/annotation
ANNOVAR_PERL=/home/liucj/tools/annovar
mkdir $ANNOVAR_OUTFILE/snp
mkdir $ANNOVAR_OUTFILE/indel

ANO_SNP_OUTFILE=$ANNOVAR_OUTFILE/snp
ANO_INDEL_OUTFILE=$ANNOVAR_OUTFILE/indel
HUMANDB=/project/liucj/REFDATA/humandb
SNP=$2
INDEL=$3
FINAL_NAME=$4.$5
#OONVERT VCF TO ANNOVAR INPUT FILE
perl $ANNOVAR_PERL/convert2annovar.pl -format  vcf4 -i $SNP > $ANO_SNP_OUTFILE/$FINAL_NAME.snp.final.vcf.avinput

perl $ANNOVAR_PERL/convert2annovar.pl -format  vcf4 -i $INDEL > $ANO_INDEL_OUTFILE/$FINAL_NAME.indel.final.vcf.avinput

#annotation
perl $ANNOVAR_PERL/table_annovar.pl \
$ANO_INDEL_OUTFILE/$FINAL_NAME.indel.final.vcf.avinput \
$HUMANDB \
-buildver hg19 \
-protocol refGene,ensGene,knownGene,ccdsGene,sift,cosmic65,esp6500si_all \
-operation g,g,g,g,f,f,f \
-nastring . \
-outfile $ANO_INDEL_OUTFILE/$FINAL_NAME.indel.final.vcf.avinput

perl $ANNOVAR_PERL/table_annovar.pl \
$ANO_SNP_OUTFILE/$FINAL_NAME.snp.final.vcf.avinput \
$HUMANDB \
-buildver hg19 \
-protocol refGene,ensGene,knownGene,ccdsGene,sift,cosmic65,esp6500si_all \
-operation g,g,g,g,f,f,f \
-nastring . \
-outfile $ANO_SNP_OUTFILE/$FINAL_NAME.snp.final.vcf.avinput









