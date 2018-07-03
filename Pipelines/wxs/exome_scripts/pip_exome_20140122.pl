#!/usr/bin/perl

#Wed Jan 22 17:07:10 CST 2014
#AUTHOR: C.J. LIU
#AIM: PIPLINE 11 SAMPLES 
use strict;
use File::Basename;

my @list = `ls /project/liucj/SAMPLE/exomeData/liujingyu/exome_11samples_20140121/Project_s063e03002/*/*`;
my $pipeDir = '/home/liucj/piplines/piplines/exomePipeline';
my $processDir = '/project/liucj/PROCESS/exome/liujingyu/exome_11samples_20140121';


my $NO = 0;
my $inputName1;
my $inputName2;
foreach my $fullName (@list){
	chomp $fullName;
	if($fullName =~ /.*fastq$/){
		my $DIR = dirname($fullName);
		my $FILE = basename($fullName);
		my @array = split("/", $DIR);
		my $outDir = $array[-1];
		#print $DIR."\n"; 
		#print $FILE."\n";
		#print $outDir."\n";
		$NO++;
		#print "$NO\n";
		if(($NO % 2) == 1){
			$inputName1 = $FILE;
		}
		if(($NO % 2) == 0){
			$inputName2 = $FILE;
			`mkdir "$processDir/$outDir"`;
			#print "$inputName1\t$inputName2\t$DIR\t$processDir/$outDir\n";
			system("perl $pipeDir/myExomePipeline1.8.pl $inputName1 $inputName2 $DIR $processDir/$outDir"); 
		}
		
		
	}

}

