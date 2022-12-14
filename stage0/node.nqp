class Node {
	has %!data;
	has %!actions;

	method new_type() {
		my $meta-object := self.new();
		return nqp::newtype($meta-object, 'HashAttrStore');
	}

	method add_method($type, $name, $code) {
		%!actions{$name} := $code;
	}

	method find_method($type, $name) {
		%!actions{$name}; 
	}

	method add_data($name, $value) {
		%!data{$name} := $value;
	}

	method get_data($name) {
		return %!data{$name};
	}

	method dump_data($name) {
		my $str :=  "add_data( " ~ $name ~ ", " ~ %!data{$name} ~ ")";
		return $str;
	}

}

my $type := Node.new();

# Add a method.
$type.HOW.add_method($type, 'drink', -> $self {
	say("mmmm...Starobrno!")
});

my $obj := nqp::create($type);

$obj.drink();  # Call the method
$obj.add_data('name', 'node');
$obj.add_data('Description', 'Our basic building block.');
my $x := $obj.get_data('name');
say($x);

