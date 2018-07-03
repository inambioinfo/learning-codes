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
perl /home/liucj/piplines/piplines/liujjy/vcf.avinput_2_avinput.mod.pl $ANO_SNP_OUTFILE/$FINAL_NAME.snp.final.vcf.avinput

perl $ANNOVAR_PERL/convert2annovar.pl -format  vcf4 -i $INDEL > $ANO_INDEL_OUTFILE/$FINAL_NAME.indel.final.vcf.avinput
perl /home/liucj/piplines/piplines/liujjy/vcf.avinput_2_avinput.mod.pl $ANO_INDEL_OUTFILE/$FINAL_NAME.indel.final.vcf.avinput



#annotation
perl $ANNOVAR_PERL/table_annovar.pl \
$ANO_INDEL_OUTFILE/$FINAL_NAME.indel.final.vcf.avinput \
$HUMANDB \
-buildver hg19 \
-protocol refGene,ensGene,knownGene,ccdsGene,sift,cosmic65,esp6500si_all \
-operation g,g,g,g,f,f,f \
-nastring . \
-outfile $ANO_INDEL_OUTFILE/$FINAL_NAME.indel.final.vcf.avinput

perl /home/liucj/piplines/piplines/liujjy/annovar_avinput.mod_intersection.pl \
 -anno $ANO_INDEL_OUTFILE/$FINAL_NAME.indel.final.vcf.avinput.hg19_multianno.txt \
 -mod $ANO_INDEL_OUTFILE/$FINAL_NAME.indel.final.vcf.avinput.mod 

perl /home/liucj/piplines/piplines/liujjy/GMAF_2_anno.pl -i $ANO_INDEL_OUTFILE/$FINAL_NAME.indel.final.vcf.avinput.hg19_multianno.txt.qual 

perl /home/liucj/piplines/piplines/liujjy/get_GMAF_ls_0.2.pl $ANO_INDEL_OUTFILE/$FINAL_NAME.indel.final.vcf.avinput.hg19_multianno.txt.qual.GMAF

awk -f /home/liucj/piplines/piplines/liujjy/indel_ExonicFunc.refGene.awk18 $ANO_INDEL_OUTFILE/$FINAL_NAME.indel.final.vcf.avinput.hg19_multianno.txt.qual.GMAF.ls_0.2 >$ANO_INDEL_OUTFILE/$FINAL_NAME.indel.final.vcf.avinput.hg19_multianno.txt.qual.GMAF.ls_0.2.ns

grep -v "rs" $ANO_INDEL_OUTFILE/$FINAL_NAME.indel.final.vcf.avinput.hg19_multianno.txt.qual.GMAF.ls_0.2.ns>$ANO_INDEL_OUTFILE/$FINAL_NAME.indel.final.vcf.avinput.hg19_multianno.txt.qual.GMAF.ls_0.2.ns.nodbsnp

perl /home/liucj/piplines/piplines/liujjy/get_GMAF_ls_0.05.pl $ANO_INDEL_OUTFILE/$FINAL_NAME.indel.final.vcf.avinput.hg19_multianno.txt.qual.GMAF

awk -f /home/liucj/piplines/piplines/liujjy/indel_ExonicFunc.refGene.awk18 $ANO_INDEL_OUTFILE/$FINAL_NAME.indel.final.vcf.avinput.hg19_multianno.txt.qual.GMAF.ls_0.05 >$ANO_INDEL_OUTFILE/$FINAL_NAME.indel.final.vcf.avinput.hg19_multianno.txt.qual.GMAF.ls_0.05.ns

grep -v "rs" $ANO_INDEL_OUTFILE/$FINAL_NAME.indel.final.vcf.avinput.hg19_multianno.txt.qual.GMAF.ls_0.05.ns>$ANO_INDEL_OUTFILE/$FINAL_NAME.indel.final.vcf.avinput.hg19_multianno.txt.qual.GMAF.ls_0.05.ns.nodbsnp



perl $ANNOVAR_PERL/table_annovar.pl \
$ANO_SNP_OUTFILE/$FINAL_NAME.snp.final.vcf.avinput \
$HUMANDB \
-buildver hg19 \
-protocol refGene,ensGene,knownGene,ccdsGene,sift,cosmic65,esp6500si_all \
-operation g,g,g,g,f,f,f \
-nastring . \
-outfile $ANO_SNP_OUTFILE/$FINAL_NAME.snp.final.vcf.avinput

perl /home/liucj/piplines/piplines/liujjy/annovar_avinput.mod_intersection.pl \
 -anno $ANO_SNP_OUTFILE/$FINAL_NAME.snp.final.vcf.avinput.hg19_multianno.txt \
 -mod $ANO_SNP_OUTFILE/$FINAL_NAME.snp.final.vcf.avinput.mod

perl /home/liucj/piplines/piplines/liujjy/GMAF_2_anno.pl -i $ANO_SNP_OUTFILE/$FINAL_NAME.snp.final.vcf.avinput.hg19_multianno.txt.qual

perl /home/liucj/piplines/piplines/liujjy/get_GMAF_ls_0.2.pl $ANO_SNP_OUTFILE/$FINAL_NAME.snp.final.vcf.avinput.hg19_multianno.txt.qual.GMAF

awk -f /home/liucj/piplines/piplines/liujjy/snp_ExonicFunc.refGene.awk18 $ANO_SNP_OUTFILE/$FINAL_NAME.snp.final.vcf.avinput.hg19_multianno.txt.qual.GMAF.ls_0.2 >$ANO_SNP_OUTFILE/$FINAL_NAME.snp.final.vcf.avinput.hg19_multianno.txt.qual.GMAF.ls_0.2.ns

grep -v "rs" $ANO_SNP_OUTFILE/$FINAL_NAME.snp.final.vcf.avinput.hg19_multianno.txt.qual.GMAF.ls_0.2.ns>$ANO_SNP_OUTFILE/$FINAL_NAME.snp.final.vcf.avinput.hg19_multianno.txt.qual.GMAF.ls_0.2.ns.nodbsnp 


perl /home/liucj/piplines/piplines/liujjy/get_GMAF_ls_0.05.pl $ANO_SNP_OUTFILE/$FINAL_NAME.snp.final.vcf.avinput.hg19_multianno.txt.qual.GMAF

awk -f /home/liucj/piplines/piplines/liujjy/snp_ExonicFunc.refGene.awk18 $ANO_SNP_OUTFILE/$FINAL_NAME.snp.final.vcf.avinput.hg19_multianno.txt.qual.GMAF.ls_0.05 >$ANO_SNP_OUTFILE/$FINAL_NAME.snp.final.vcf.avinput.hg19_multianno.txt.qual.GMAF.ls_0.05.ns

grep -v "rs" $ANO_SNP_OUTFILE/$FINAL_NAME.snp.final.vcf.avinput.hg19_multianno.txt.qual.GMAF.ls_0.05.ns>$ANO_SNP_OUTFILE/$FINAL_NAME.snp.final.vcf.avinput.hg19_multianno.txt.qual.GMAF.ls_0.05.ns.nodbsnp 


