#!/usr/bin/perl 
use strict;
use warnings;
use Getopt::Long;


#Tue Feb 18 16:00:36 CST 2014
#infile1 == avinput
#infile2 == snp.vcf
my %opts;
GetOptions(\%opts, "anno=s", "mod=s", "h");
my $usage = <<"USAGE";
Description:
	perl script used to integrate anno file.txt with avinput.mod to get LIU's results;
Usage:
	perl program.pl [options] file
Options:
	-anno 	annotated file 
	-mod 	avinput modified file 
	-h 	help
Example:
	perl pragram.pl -anno file.txt -mod avinut.mod 
USAGE


if( !defined($opts{'anno'}) and !defined($opts{'mod'}) or defined($opts{'h'}) ){
	print $usage;
	exit 1;
}


my($infile1, $infile2 ) = ($opts{'anno'}, $opts{'mod'});
my $outfile = "$infile1.qual";
open(IN1, "<$infile1") or die("Error: cant open file ");
open(IN2, "<$infile2") or die("Error: cant open file");
open(OUT, ">$outfile") or die("Error: cant open file");

#my %list1;
my %list2;
while(my $line = <IN2>){
        chomp $line;
        my @array = split(/\t/, $line);
	my $chr = shift @array;
	my $pos = shift @array;
        my $tmp = "${chr}_${pos}";
        $list2{$tmp} = join("\t", @array);
#	print $list2{$tmp}."\n";
}
#print OUT "Chr	Start	End	Ref	Alt	ID	QUAL	DP	QD	MQ	GT	AD	Func.refGene	Gene.refGene	ExonicFunc.refGene	AAChange.refGene	Func.ensGene	Gene.ensGene	ExonicFunc.ensGene	AAChange.ensGene	Func.knownGene	Gene.knownGene	ExonicFunc.knownGene	AAChange.knownGene	Func.ccdsGene	Gene.ccdsGene	ExonicFunc.ccdsGene	AAChange.ccdsGene	sift_score	.	cosmic65	esp6500si_all";
while(my $line = <IN1>){
	chomp $line;
	my @array = split(/\t/, $line);
	my $chr = shift @array;
	my $start = shift @array;
	my $end = shift @array;
	my $ref = shift @array;
	my $alt = shift @array;
	my $newline = join("\t", @array);
	my $key = "${chr}_${start}";
	print OUT "$chr\t$start\t$end\t$ref\t$alt\t$list2{$key}\t$newline\n";
	
}

close OUT;
close IN1;
close IN2;







