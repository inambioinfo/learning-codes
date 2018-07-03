BEGIN{
	FS="	";
}
{
if($6=="exonic"){
	print $0;
}
}
