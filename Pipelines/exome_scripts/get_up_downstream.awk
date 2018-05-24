BEGIN{
	FS="	";
	}
{

	if($16~/upstream/ || $16=="downstream") print $0;

}

