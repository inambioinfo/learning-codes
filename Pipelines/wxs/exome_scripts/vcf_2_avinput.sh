#!/bin/bash

ANNO="/home/liucj/tools/annovar"

perl $ANNO/convert2annovar.pl -format vcf4 -i $1 >$1.avinput


