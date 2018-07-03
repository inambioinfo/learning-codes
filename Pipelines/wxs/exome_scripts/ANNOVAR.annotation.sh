#!/bin/bash

#Wed Jan 15 18:46:45 CST 2014
#AUTHOR: C.J. LIU
#AIM: A SCRIPT FOR SIMPLIFIED ANNOTATION
#USAGE: bash ANNOVAR.annotation.sh file.vcf 

FILE=$1
DIR=$2

HUMANDB=/project/liucj/REFDATA/humandb
ANNOVAR_PERL=/home/liucj/tools/annovar

mkdir $DIR/annotation
OUTPUT_DIR=$DIR/annotation

#CONVERT VCF FILE TO ANNOVAR INPUT FILE
perl $ANNOVAR_PERL/convert2annovar.pl -format vcf4 \
$DIR/$FILE >$DIR/$FILE.avinput

#ANNOTATION
perl $ANNOVAR_PERL/table_annovar.pl \
$DIR/$FILE.avinput \
$HUMANDB \
-buildver hg19 \
-protocol refGene,ensGene,knownGene,ccdsGene,sift,snp137,cosmic65,esp6500si_all \
-operation g,g,g,g,f,f,f,f \
-nastring . \
-outfile $OUTPUT_DIR/$FILE.avinput




