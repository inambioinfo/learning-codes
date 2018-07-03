BEGIN{
	FS="	";
	}
{

	if($16=="splicing") print $0;

}

