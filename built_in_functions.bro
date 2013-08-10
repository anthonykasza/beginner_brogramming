global s: string = "123 example 123";
global c: count = 10;
global d: double = 3.8;
global p: pattern = / /;

event bro_init()
{
	local tmp: string_array = split(s, p);
	if ( is_ascii(s) )
	{
		for (each in tmp)
		{
			print tmp[each];
		}
	}
}

print current_time();
print count_to_port(c, tcp);
print floor(d);

