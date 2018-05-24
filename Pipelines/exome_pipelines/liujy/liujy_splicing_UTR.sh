#!/bin/bash
#########add splicing, UTR, up_down stream######
#######liujy 11 exome supplementary data######
######input GMAF data#####

#GMAF=$1;
#perl /home/liucj/piplines/piplines/liujjy/get_GMAF_ls_0.05.pl $GMAF

INPUT=$1;
########UTR get_UTR.awk####
awk -f /home/liucj/piplines/piplines/liujjy/get_UTR.awk $INPUT>$INPUT.UTR
########nc_UTR get_nc_UTR.awk####
awk -f /home/liucj/piplines/piplines/liujjy/get_nc_UTR.awk $INPUT>>$INPUT.UTR

########splicing get_splicing_awk######
awk -f /home/liucj/piplines/piplines/liujjy/get_splicing.awk $INPUT>$INPUT.splicing

#######up_down_stream get_up_downstream.awk####
awk -f /home/liucj/piplines/piplines/liujjy/get_up_downstream.awk $INPUT>$INPUT.upDownStream






