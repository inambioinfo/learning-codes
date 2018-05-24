################################################
#File Name: hasharray.pl
#Author: C.J. Liu
#Mail: samliu@hust.edu.cn
#Created Time: Thu 11 Sep 2014 06:32:31 PM CST
################################################

#!/usr/bin/perl -w
use strict;
use Getopt::Long;
use File::Basename;
use Data::Dumper;
use Switch;

#this file should be used to add ref and alt with count and freq in the annotation process
#the input file must be *.multianno.txt

my $start = time;
my $mod = '/project/liucj/REFDATA/humandb/hg19_snp137.txt.mod.v2';
open(MOD, "<$mod") or die("ERROR: can not open file:$!\n");

sub strand{							#change the strand.
	my $strand = shift @_;
	my @array = ();
	if($strand eq '-'){
		my $allele = "@_";
		if($allele =~ /-/){return @_;}
		else{
			foreach (@_){
				push @array, &change($_);
			}
			return @array;
		}
	}
	elsif($strand eq '+'){
		return @_;
	}
}

sub change{
	return $_ if length $_ > 1;

	if(length $_ == 1){
		switch($_){
			case 'A' {return 'T';}
			case 'G' {return 'C';}
			case 'C' {return 'G';}
			case 'T' {return 'A';}
			else {return $_;}
		}
	}
}



my %hash;
while(<MOD>){
	chomp;
	my @array = split/\t/;
	#$hash{$array[3]}=$array[4].'_'.$array[7].'_'.$array[8].'_'.$array[9].'_'.$array[10];
	if($array[7] == 0){
		$hash{$array[3]} = '.';
	}else{
		my @allele = split /,/, $array[8];
		my @count = split/,/, $array[9];
		my @freq = split/,/, $array[10];
		@allele = &strand($array[5], @allele);
		for(my $i = 0; $i < @allele; $i ++ ){
			$hash{$array[3]}{$allele[$i]} = [$count[$i], $freq[$i]];
		}
	}
}
close MOD;
=pod
foreach(keys %hash){
	print "$_\t";
	print Dumper($hash{$_});
}
=cut

my ($file) = @ARGV;
open(IN,"<$file") or die("cant open file:$file\t$!\n");
my $out = $file.".maf";
open(OUT, ">$out") or die("ERROR: cant open file:$out\t$!\n");
while(<IN>){
	chomp;
	my ($refcount, $altcount, $reffreq, $altfreq) = qw/. . . ./;
	my ($ref, $alt, $rs) = (split/\t/)[3, 4, 24];
	if(defined $hash{$rs} and $hash{$rs} ne '.'){
		
		($refcount, $reffreq) = @{$hash{$rs}{$ref}} if defined @{$hash{$rs}{$ref}};
		($altcount, $altfreq) = @{$hash{$rs}{$alt}} if defined @{$hash{$rs}{$alt}};
	}
	print OUT "$_\t$refcount\t$altcount\t$reffreq\t$altfreq\n";
}
close IN;
close OUT;
#print time - $start;
