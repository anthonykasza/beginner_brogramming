# scheduling and when
global x: count = 0;

event e(c: count)
{
        print c;
        x = c;
}

schedule 10 sec { e(2) };
schedule 15 sec { e(10) };

when (x == 10)
{
        print "x now equals 10";
}



# conditionals
local b1: bool = T;
local b2: bool = F;

if (b2)
{
	print "b2 is False, this should never print...";
} else if (b2)
{
	print "b2 is still False, dumby";
} else
{
	print "you should see this statement";
}

local s: string;
b1 ? (s = "b1 is true") : (s = "b1 was false");
print s;
print "";



#loops
local ss: set[string] = {
	"one",
	"two",
	"three",
	"four",
};

for (s in ss)
{
	print s;
}
print "";
