BEGIN{
	FS="	";
}
{
	if($8=="nonsynonymous SNV"){
		print $0;
	}

}
