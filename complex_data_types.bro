# records
type NewType: record {
       	s1: string;
        c: count &default = 0;
        s2: string &optional;
};

local r1: NewType;
r1 = [$s1="a required string", $c=11, $s2="an optional string"];
print r1;

local r2: NewType;
r2 = [$s1="a required string"];
print r2;


# sets
local my_port: port = 80/tcp;
local my_ports: set [port] = {22/tcp, 53/udp, 8080/tcp};
local my_port_lookups: set [port, string] = { 
	[22/tcp, "ssh"], 
	[53/udp, "dns"], 
	[8080/tcp, "http-alt"], 
	[23/tcp, "telnet"],
	[1337/tcp, "farts! farts!"],
};

add my_ports[my_port];
add my_port_lookups[my_port, "http"];
delete my_ports[my_port];

local my_ports_size_c: count = |my_ports|;
local my_ports_size_i: int = |my_ports|; 

print ( |my_ports| );


# tables
local port_table: table[port] of string = {
        [80/tcp] = "http, whatever...",
        [53/udp] = "dns, boring...",
        [443/tcp] = "https, i can't see, but stil..",
        [1337/tcp] = "FARTS!",
};

for (each in port_table)
{
	print each, port_table[each];
}



