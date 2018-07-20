################################################
#File Name: kel.thread_2.pl
#Author: C.J. Liu
#Mail: samliu@hust.edu.cn
#Created Time: Wed 04 Mar 2015 09:50:54 AM CST
################################################

#!/usr/bin/perl -w
use strict;
use warnings;
use Getopt::Long;
use File::Basename;

use threads;
use Thread::Semaphore;

my $j = 0;
my $thread;
my $max_threads = 5;
my $semaphore = new Thread::Semaphore($max_threads);

print localtime(time), "\n";

while(){
	last if $j > 10;
	$j ++;

	$semaphore->down();

	my $thread = threads->new(\&ss, $j, $j);
	$thread->detach();

}
&waitquit;

sub ss(){
	my ($t,$s) = @_;
	sleep($t);
	print "$s\t", scalar(threads->list()),"\t$j\t", localtime(time), "\n";
	$semaphore->up();
}

sub waitquit{
	print "Waiting to quit..\n";
	my $num = 0;
	while($num < $max_threads){
		$semaphore->down();
		$num ++;
		print "$num thread quit...\n";
	}
	print "all $max_threads thread quit\n";

}

