#!/usr/bin/awk -f
BEGIN{
		FS="\t";
	}
	{	if(NR==1) print $0; 
		
		if($8=="." || $8 < 0.05 || $10=="." || $10 < 0.05){
				print $0;
			}
		
		}
