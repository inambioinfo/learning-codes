BEGIN{
	FS="	";
	}
{

	if($16~/ncRNA_UTR/) print $0;

}

