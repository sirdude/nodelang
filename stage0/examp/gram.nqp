token key { \w+ }
token value { \N+ }
token entry { <key> \h* '=' \h* <value> }
# This is the same as the token line above...
# rule entry { <key> '=' <value> }
# This is already defined by default
token ws { \h* }

# First attempt
#token TOP {
#	^	
#	[
#	| <entry> \n
#	| \n
#	]+
#	$
#}
#

token entries {
	[
	| <entry> \n
	\n
	]+
}

token section {
	'[' ~ ']' <hey> \n
	<entries>
}

token TOP {
	^
	<entries>
	<section>+
	$
}
