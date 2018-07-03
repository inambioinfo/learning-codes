#!/bin/bash
#############
#$1 $ourdir
#$2 $finalSNP
#$3 $finalINDEl
#$4 $pe1
#$5 $pe2
#$6 $reference ##now i dont have hg 38 data, so genome reference is hg19
########################################################################

#annotation out file
mkdir $1/annotation
ANNOVAR_OUTFILE=$1/annotation
ANNOVAR_PERL=/home/liucj/tools/annovar
SCRIPT=/home/liucj/piplines/scripts

mkdir $ANNOVAR_OUTFILE/snp
mkdir $ANNOVAR_OUTFILE/indel

ANO_SNP_OUTFILE=$ANNOVAR_OUTFILE/snp
ANO_INDEL_OUTFILE=$ANNOVAR_OUTFILE/indel
HUMANDB=/project/liucj/REFDATA/humandb
SNP=$2
INDEL=$3
FINAL_NAME=$4.$5
#OONVERT VCF TO ANNOVAR INPUT FILE

if [ -f $INDEL ]
then
{
perl $ANNOVAR_PERL/convert2annovar.pl -format  vcf4 -i $INDEL > $ANO_INDEL_OUTFILE/$FINAL_NAME.indel.final.vcf.avinput 

perl $ANNOVAR_PERL/table_annovar.pl \
$ANO_INDEL_OUTFILE/$FINAL_NAME.indel.final.vcf.avinput \
$HUMANDB \
-buildver hg19 \
-protocol refGene,ensGene,knownGene,ccdsGene,sift,cosmic65,esp6500si_all,snp137 \
-operation g,g,g,g,f,f,f,f \
-nastring . \
-outfile $ANO_INDEL_OUTFILE/$FINAL_NAME.indel 

#perl $SCRIPT/maf_stat.pl $ANO_INDEL_OUTFILE/$FINAL_NAME.indel.hg19_multianno.txt 
python $SCRIPT/add_maf_to_txt.py $ANO_INDEL_OUTFILE/$FINAL_NAME.indel.hg19_multianno.txt > $ANO_INDEL_OUTFILE/$FINAL_NAME.indel.hg19_multianno.txt.maf

perl $SCRIPT/exome_demand_snp142.pl -maf $ANO_INDEL_OUTFILE/$FINAL_NAME.indel.hg19_multianno.txt.maf -avi $ANO_INDEL_OUTFILE/$FINAL_NAME.indel.final.vcf.avinput
}&
fi

if [ -f $SNP ]
then
{
perl $ANNOVAR_PERL/convert2annovar.pl -format  vcf4 -i $SNP > $ANO_SNP_OUTFILE/$FINAL_NAME.snp.final.vcf.avinput 

perl $ANNOVAR_PERL/table_annovar.pl \
$ANO_SNP_OUTFILE/$FINAL_NAME.snp.final.vcf.avinput \
$HUMANDB \
-buildver hg19 \
-protocol refGene,ensGene,knownGene,ccdsGene,sift,cosmic65,esp6500si_all,snp137 \
-operation g,g,g,g,f,f,f,f \
-nastring . \
-outfile $ANO_SNP_OUTFILE/$FINAL_NAME.snp 

#perl $SCRIPT/maf_stat.pl $ANO_SNP_OUTFILE/$FINAL_NAME.snp.hg19_multianno.txt 

python $SCRIPT/add_maf_to_txt.py $ANO_SNP_OUTFILE/$FINAL_NAME.snp.hg19_multianno.txt>$ANO_SNP_OUTFILE/$FINAL_NAME.snp.hg19_multianno.txt.maf

perl $SCRIPT/exome_demand_snp142.pl -maf $ANO_SNP_OUTFILE/$FINAL_NAME.snp.hg19_multianno.txt.maf -avi $ANO_SNP_OUTFILE/$FINAL_NAME.snp.final.vcf.avinput
	}&
fi

