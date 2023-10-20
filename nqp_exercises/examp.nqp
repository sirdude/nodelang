class SimpleMetaObject {
	has %!methods;

	method new_type() {
		my $meta-object := self.new();
		return nqp::newtype($meta-object, 'HashAttrStore');
	}

	method add_method($type, $name, $code) {
		%!methods{$name} := $code;
	}

	method find_method($type, $name) {
		%!methods{$name} 
	}
}

my $type := SimpleMetaObject.new();

# Add a method.
$type.HOW.add_method($type, 'drink', -> $self {
	say("mmmm...Starobrno!")
});

my $obj := nqp::create($type);

$obj.drink();  # Call the method

