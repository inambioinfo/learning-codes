BEGIN{
	FS="	";
	}
{

	if($16~/ncRNA_exonic/) print $0;

}

