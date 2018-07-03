BEGIN{
	FS="	";
	}
{

	if($16=="ncRNA_splicing") print $0;

}

