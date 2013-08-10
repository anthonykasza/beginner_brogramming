##! Describe the module here.
##! What does it do? Who does it call? How does it work?
##! This will possibly be used for auto-generated documentation, so explain things well.
##!
##! For readability and constancy, be sure to follow scripting conventions outlined here:
##!	http://www.bro.org/development/script-conventions.html
##!

# The best way to learn to program with Bro is by reading other Bro programs.
# Explore the Bro directory structure and read .bro scripts.
# A good script to explorer is base/protocols/conn/main.bro

# The following line will import scripts from the defined path, in this case base.
# If writing a script for a specific framework, it only makes sense to import that framework's scripts.
# Think of @load as Perl's use, Python's import, Ruby's require, or C's #include.
@load base/frameworks/logging

# This creates a new namespace Template.
# Name the module by replacing 'Template'.
module Template;

# Export the module so the rest of Bro can use and is affected by it's goodness.
export {

	# Create new constant variable for other pieces of Bro to use.
	#	const is the variable scope. global and local are other common options.
	# 	test_message is the name of the variable.
	#	string is the type of the variable. Bro has a large selection of strict variable types.
	# 	The text in quotes is the value of the variable.
	# 	&redef makes the variable redefinable along the way. It is convention to add this to all const varibales.
	#		&redef is one of many variable attributes which alter the behavior of the variable
	const template_message: string = "This is the message from the template" &redef;

	# The below line redefines a piece of the framework Bro uses to log stuff.
	# It adds an addition stream (logging thing), called TEMP_LOG, to what Bro currently uses to log stuff.
	# Bro logs things that it sees happen with the use of three things. 
	#	Log stream 	- A single log. Streams include what is included in a log (e.g. fields and field names). 
	#	Filters 	- A set of things that describe what information is written to a stream. 
	#			- Filters trim down or change the behavior of streams.
	#			- Each stream has a default filter that logs everything. 
	#			- Filters can duplicate streams, split streams into multiple streams, and subset streams.
	#	Writers		- Alter how the log stream is output. Text files, binary files, database, etc. 
	#			- Default behavior dictates ASCII files are written to the directory Bro is called from.
	redef enum Log::ID += { TEMP_LOG };

	# The below line defines the record type for this module's log stream.
	# Records are lines in a log stream. Records consist of fields. Each field has a type and a name.
	# When the time comes, an instance of Template::Info (this module's record type) will be passed to Bro's logging framework
	# When does the time come? When Bro witnesses a defined event on the network. Events are explained below.
	type Info: record {
		# The first field in this record is named ts
		# ts has a type of time
		# ts has an attribute of &log (this just means log the variable to a field in a record)
		ts: time &log;
		# The second field in this records is the constant string defined above.
		template_message: string &log;
	};

	# A new log ID has been created, a new record has been defined, and now it is time to define a hook event.
	# The below line declares a global variable named template_log_hook with a type of event. 
	# The event takes one parameter named rec of type Info (which has been defined above with a type record).
	# Events are described below and are similar (but not the same) to signal handling in C. 
	global template_log_hook: event(rec: Info);

}

# Bro has the concept of events. Events occur throughout a Bro instance's life. The initialization of Bro happens when Bro begins running.
# The first event which happens is named bro_init. The very last event that happens is bro_done. 
# Bro has events about its internals as well as events for things it witnesses on the network. 
# For example, the http_request event is raised each time Bro sees an HTTP request on the wire.
# A list of built-in events Bro has at a programmer's exposal are listed here:
#	http://www.bro.org/documentation/scripts/base/event.bif.html

# The following is a bro_init event. Each time Bro is started, this event will run. 
# This event is a good location to add or alter pieces of Bro.
# The bro_init event below was created with the following documentation page:
#	http://www.bro.org/documentation/logging.html
event bro_init()
{
	# The following line creates a new log stream, associates the stream with the Template module and creates the default filter.
	# The 
	Log::create_stream(Template::TEMP_LOG, [$columns=Info, $ev=template_log_hook]);
	
	# Below is a log filter definition. It inlcudes three key pieces of information about the filter.
	#	$name	- The name of the filter. This is used to refer to the filter.
	#	$path	- The path of the output file for the stream. 
	#	$incude - The fields to include. Any fields defined in the stream but not in the $include will not be included.
	#		- The $include variable is a set of strings which correspond to field names.
	#	$exclude- A set of field names to exclude from the stream. $exclude is the opposite of $include.
	local template_filter: Log::Filter = [$name="template-filter-name", $path="template-log-filepath", $include=set("ts", "template_message")];

	# The following line applies the log stream filter, template_filter to the Template module's log stream.
	Log::add_filter(Template::TEMP_LOG, template_filter);
	
	# Recall, a default filter includes all fields in a stream's record.
	# The below line removes the default filter created for the TEMP_LOG stream.
	Log::remove_filter(Template::TEMP_LOG, "default");

	# The following commented line completely disables the Template log stream. No Template log file will be created.
	# Log::disable_stream(Template::LOG);
}

# The following line defines what happens when Bro sees a new TCP connection establishes itself. 
# This event has one parameter named c of type connection. 
# Each time a TCP connection is established a line is written to the log stream.
# For more information about this event, see here:
#	http://www.bro.org/documentation/scripts/base/event.bif.html#id-connection_established
event connection_established(c: connection)
{
	# The below line defines a local varible named m of type string
	local m: string = "This is the message from the connection_established event";
	
	# The below line defines a local varibale named rec of type Template::Info
	# The Template::Info type is defined in the export function corresponding to the export function of the Template module from above.
	# The Template::Info type is a record with two variables:
	#	$ts			- named ts
	#				- type time
	#	$template_message	- named template_message
	#				- type string
	# The function network_time() is a built-in-function which returns the timestamp of the most recently seen packet.
	local rec: Template::Info = [$ts=network_time(), $template_message=do_it(m)];
	
	# The write function from the Log namespace takes two parameters. The log stream ID to write to and the field values.
	# The stream ID is the stream defined in the Template module above and the field values are in the local record variable
	# named rec.
	# The following link contains a description of this built in function:
	#	http://www.bro.org/documentation/scripts/base/frameworks/logging/main.html#id-Log::write
	Log::write(Template::TEMP_LOG, rec);
}

# The following function hooks into an event which occurs every time Bro witnesses a DNS request happen
# Similar to the above event, a line is written to the custom log stream.
# This event has five paramters which describe the DNS request.
# More information about the dns_request event can be found here:
#	http://www.bro.org/documentation/scripts/base/event.bif.html#id-dns_request
event dns_request(c: connection, msg: dns_msg, query: string, qtype: count, qclass: count)
{
	# Similar to the connection_established event, this event declares a local variable named m of type string.
	# Unlike the connection_established event, this string consists of hard coded text concatenated with a variable 
	local m: string = "This is the message from the dns_request event. THe following name was queried for: " + query;
	
	# This line is the same as the connection_established event
	local rec: Template::Info = [$ts=network_time(), $template_message=do_it(m)];
	
	# This line is the same as the connection_established event
	Log::write(Template::TEMP_LOG, rec);
}
