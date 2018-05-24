#!/usr/bin/perl -w
################################################
#File Name: filter_by_gene.pl
#Author: C.J. Liu
#Mail: samliu@hust.edu.cn
#Created Time: Sun 14 Sep 2014 09:12:03 PM CST
################################################

use strict;
use warnings;
use Getopt::Long;
use File::Basename;
use Pod::Usage;

our ($help, $man, $verbose);
GetOptions('help|?'=>\$help,man=>\$man) or pod2usage();
pod2usage(-verbose=>1, -exitval=>1, -output=>\*STDOUT) if $help;
pod2usage(-verbose=>1, -exitval=>1, -output=>\*STDOUT) if $man;

my $ens = "/project/liucj/PROCESS/exome/liumugen/20140829/WJ/result/indel/genelist/bioDBnet_db2db_genelist.txt";
my %hash;
open ENS, "<$ens" or die "error: cant open file:$ens,$!\n";
while(<ENS>){
	chomp;
	my @array = split "\t";
	my @keys = split "; ", $array[1];
	foreach (@keys){
		$hash{$_} = $array[0];
	}

}
close ENS;

foreach (@ARGV){
	open IN, "<$_" or die "error: cant open file:$_\n";
	open OUT, ">$_.filter" or die "error: cant open file:$_.filter\n";
	while(<IN>){
		chomp;
		print OUT $_,"\n" if /^chr\tstart/;
		my @array = split "\t";
		my $key = $array[14];
		$hash{$key} and print OUT "$_\t$hash{$key}\n";
	}
	close IN;
	close OUT;
}

=head1 SYNOPSIS
retnet.filter.pl [*]

=over 8
=item B<Option arguments:>
-help	help
-man	man

=item B<Example>
retnte.filter.pl *ns

Version: Tue Sep  1 12:43:52 CST 2015

=back

=head1 DESCRIPTION
B<retnet.pl> is a script for liumg to filter genes from retnet.db; 




