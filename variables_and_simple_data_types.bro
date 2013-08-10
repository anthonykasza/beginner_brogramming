global myname: string = "anthony";

event bro_init()
{
	local myage: count = 42;
	print fmt("my name is %s and my age is %d", myname, myage);
}

event bro_done()
{
	local myage: count = 42 + 9;
	print fmt("my name is %s and my age is %d", myname, myage);
}
