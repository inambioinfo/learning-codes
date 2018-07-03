BEGIN{
	FS="	";
}
{
	if($16!="intergenic" && $16!="intronic" && $16!="ncRNA_intronic") print $0;


}
