BEGIN{
	FS="	";
	}
{

	if($16~/upstream/) print $0;

}

