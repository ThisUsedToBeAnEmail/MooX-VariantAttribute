package t::odea::Test;

use Moo;
use MooX::VariantAttribute;

variant parser => (
    given => Obj,
    when => [
        'Test::Parser::One' => {
            alias => {
                parse_string => 'parse',
                # parse_file exists 
            },
        },
        'Random::Parser::Two' => {
            alias => {
                # parse_string exists
                parse_file   => 'parse_from_file', 
            },
        },
        'Another::Parser::Three' => {
            alias => { 
                parse_string => 'meth_one',
                parse_file   => 'meth_two', 
            },
        },
    ],
);

variant string => (
    given => Str,
    when => [
        'one' => { 
            run => sub { return "$_[0] - cold, cold, cold inside" },
        },
        'two' => {
            run => sub { return "$_[0] - don't look at me that way"; },
        },
        'three' => {
            run => sub { return "$_[0] - how hard will i fall if I live a double life"; },
        },
    ],
);

variant refs => (
    given => sub { ref $[0] }, 
    when => [
        'SCALAR' => { 
            run => sub { return "I'm a Scalar - $_[0]" },
        },
        'HASH' => {
            run => sub { return "I'm a Hash -" . join ',', map { sprintf '%s=>%s', $_, $_[0]->{$_} } keys %{ $_[0] }; },
        },
        'ARRAY' => {
            run => sub { return "I'm a Array - " . join ',', @{ $_[0] } },
        },
    ],
);

=pod

    has parser => (
        is => 'rw',
        setter => '_set_parser',
    );

    has string => (
        is => 'rw',
        setter => '_set_string',
    );

    has refs => (
        is => 'rw',
        setter => '_set_refs',
    );

=cut

1;
