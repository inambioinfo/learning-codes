#!/usr/bin/perl -w
################################################
#File Name: liucj.pl
#Author: C.J. Liu
#Mail: samliu@hust.edu.cn
#Created Time: Sat 13 Sep 2014 05:48:25 PM CST
################################################

use strict;
use warnings;
use Getopt::Long;
use File::Basename;
use Data::Dumper;
use Pod::Usage;

our ($help, $man, $verbose);
our ($normal, $unnormal);
GetOptions('normal|n=s'=>\$normal, 'unnormal|u=s'=>\$unnormal, 'help|?' =>\$help, man => \$man) or pod2usage();

pod2usage(-verbose=>1, -exitval=>1, -output=>\*STDOUT) if $help;
pod2usage(-verbose=>2, -exitval=>1, -output=>\*STDOUT) if $man;

my (@normal, @unnormal, @normalBin, @unnormalBin);
&processArgument;
#print "@unnormal";
@unnormalBin = storeInHash(@unnormal);

#print Dumper $unnormalBin[0];
=pod
foreach (keys %{$unnormalBin[0]}){
	#	print $unnormalBin[0]{$_}[0]."\n";
	print $_."\n";
}
=cut

if( defined $normal){
	@normalBin = &storeInHash(@normal);	
}

if( defined $unnormal ){
	@unnormalBin = &storeInHash (@unnormal);
	open IN, "<$unnormal[0]" or die "error: cant open file: $!\n";
	@unnormal > 1 and shift @unnormalBin;

	while(<IN>){
		chomp;
		my @array = split "\t";
		my $key = join "#", @array[0,1,2,3,4];	
		if(@unnormal > 1){
			if(!defined $normal){
				if (defined @{$unnormalBin[0]{$key}}){
					splice @array, 10, 0, @{$unnormalBin[0]{$key}};
					my $record = join "\t", @array;
					print "$record\n";
					}
				}
			elsif(defined $normal){
				if(defined @{$unnormalBin[0]{$key}} and !defined @{$normalBin[0]{$key}}){
					splice @array, 10, 0, @{$unnormalBin[0]{$key}};
					my $record = join "\t", @array;
					print "$record\n";
					}
				}
			}
		elsif(@unnormal == 1){
			$normal or pod2usage("ERROR in input normal file, at least one input normal file\n");
			if(defined $normal){
				if(!defined @{$normalBin[0]{$key}}){
				print "$_\n";

				}
			}
		}
		
		}
		close IN;
	}





sub storeInHash{
	my @array = @_;
	my @result;
	for(my $i = 0; $i < @array; $i++){
		open IN, "<$array[$i]" or die "error: can not file: $array[$i]\n$!\n";
		my $ref;
		while(<IN>){
			chomp;
			my $key = join "#", (split "\t")[0,1,2,3,4];
			my @value = (split "\t")[10, 11, 12];
			${$ref}{$key} = [ @value ]; 
		}
		push @result, $ref;
		close IN;
	}
	return @result;
}

sub processArgument{
	@normal = split ",", $normal if defined $normal;
	@unnormal = split ",", $unnormal if defined $unnormal;
}






=head1 SYNOPSIS

intersection.pl [options] [file ...]

=over 8

=item B<Optional arguments:>
-n, --normal		input normal file, normal is to produce complementary set, several input files must be seperated by comma with no space, now limit one input file
-u, --unnormal		input unnormal file, unnormal is to produce intersection set, several input files must be seperated by comma with no space, now input 2 files
-help		brief help message
-man		full decumentation

=item B<Example:>
intersection.pl		-n normal.maf.txt.splicng	-u unnormal.maf.txt.splicing\n
intersection.pl		-u unormal1.maf.txt.splicing	unnormal2.maf.txt.splicing

Version: Sat Sep 13 22:05:52 CST 2014

=back

=head1 OPTIONS

=over 8

=item B<--normal,-n>

Input normal files, We would like to get unnoraml intersection, and unnormal complementary set with normal SNV.

=item B<--unormal,-u>

Input normal files, We would like to get unnoraml intersection, and unnormal complementary set with normal SNV.

=item B<-help>

Print a brief help message and exits.

=item B<-man>

Prints the manual page and exits


=back

=head1 DESCRIPTION

B<intersection.pl> is a get intersection and complementary set of input files of normal and unnormal samples produced by my new exome pipline. This script is different from script before getting required results, This script can input more than one normal and unnormal sample annovar output files, which  producing intersection set in *.inter files and complementary set files


=cut









