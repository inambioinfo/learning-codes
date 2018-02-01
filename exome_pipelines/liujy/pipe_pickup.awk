BEGIN{
        FS="	";
}
{
        if(/^#/ || $7=="PASS") print $0;
}
