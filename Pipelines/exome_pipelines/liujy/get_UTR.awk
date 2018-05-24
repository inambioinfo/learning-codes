BEGIN{
	FS="	";
	}
{

	if($16~/^UTR/) print $0;

}

