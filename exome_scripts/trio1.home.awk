BEGIN{
	FS="\t";
	}
	{
		if(NR==1) print $0;
		if($11=="1/1" && $14=="1/1") print $0;
		}
