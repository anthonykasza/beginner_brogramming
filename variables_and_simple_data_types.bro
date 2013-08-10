global myname: string = "Rubix Tubes";

event bro_init()
{
	local myage: count = 38;
	print fmt("my name is %s and my age is %d", myname, myage);
}

event bro_done()
{
	local myage: count = 38 + 9;
	print fmt("my name is %s and my age is %d", myname, myage);
}
