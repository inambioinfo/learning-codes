#!/usr/bin/perl 

#Tue Feb 18 16:00:36 CST 2014
#infile1 == avinput
#infile2 == snp.vcf
die("ERROR: the number of input files is not 3") if(@ARGV != 3);
my($infile1, $infile2, $outfile) = @ARGV;
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
        my $tmp = $chr.$pos;
        $list2{$tmp} = join("\t", @array);
#	print $list2{$tmp}."\n";
}
print OUT "Chr	Start	End	Ref	Alt	ID	QUAL	DP	QD	MQ	GT	AD	Func.refGene	Gene.refGene	ExonicFunc.refGene	AAChange.refGene	Func.ensGene	Gene.ensGene	ExonicFunc.ensGene	AAChange.ensGene	Func.knownGene	Gene.knownGene	ExonicFunc.knownGene	AAChange.knownGene	Func.ccdsGene	Gene.ccdsGene	ExonicFunc.ccdsGene	AAChange.ccdsGene	sift_score	.	cosmic65	esp6500si_all";
while(my $line = <IN1>){
	chomp $line;
	my @array = split(/\t/, $line);
	my $chr = shift @array;
	my $start = shift @array;
	my $end = shift @array;
	my $ref = shift @array;
	my $alt = shift @array;
	my $newline = join("\t", @array);
	my $key = $chr.$start;
	print OUT "$chr\t$start\t$end\t$ref\t$alt\t$list2{$key}\t$newline\n";
	
}

close OUT;
close IN1;
close IN2;







