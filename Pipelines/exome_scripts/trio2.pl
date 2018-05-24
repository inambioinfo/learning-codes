################################################
#File Name: inter.hete.pl
#Author: C.J. Liu
#Mail: samliu@hust.edu.cn
#Created Time: Mon 08 Dec 2014 01:16:48 PM CST
################################################

#!/usr/bin/perl -w
use strict;
use warnings;
use Getopt::Long;
use File::Basename;


#number of sites > 2 in one gene
my ($file) = @ARGV;
open IN, $file or die "cant open file:$file\n";
my @array = <IN>;
print $array[0];
for(my $i = 0; $i<$#array;$i++){
	chomp $array[$i];
	my @arrayi = split "\t", $array[$i];
	my $flag = 0;

	if($arrayi[10] eq "1/1" || $arrayi[13] eq "1/1"){next;}	

	for (my $j = $i+1; $j<=$#array; $j++){
		chomp $array[$j];	
		my @arrayj = split "\t", $array[$j];
		if($arrayj[10] eq "1/1" || $arrayj[13] eq "1/1"){next;}

		if($arrayi[17] eq $arrayj[17]){
			if($flag == 0){print $array[$i],"\n";}
			print $array[$j],"\n";
			$flag ++;
			$i=$j;
		}
		
	}
}

close IN;


