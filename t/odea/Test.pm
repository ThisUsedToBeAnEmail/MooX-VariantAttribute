package t::odea::Test;

use Moo;
use MooX::VariantAttribute;

variant parser => (
    is  => 'ro',
    given =>  Obj,
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

has thing => ( 
    is => 'ro',
    default => sub { 'one' },  
);

variant string => (
    is  => 'ro',
    given => Str,
    when => [
        'one' => { 
            run => sub { return "$_[1] - cold, cold, cold inside" },
        },
        'two' => {
            run => sub { return "$_[1] - don't look at me that way"; },
        },
        'three' => {
            run => sub { return "$_[1] - how hard will i fall if I live a double life"; },
        },
    ],
    default => sub { $_[0]->thing },
);

variant refs => (
    is  => 'ro',
    given => sub { ref $_[0] }, 
    when => [
        'SCALAR' => { 
            run => sub { return "I'm a Scalar - $_[1]" },
        },
        'HASH' => {
            run => sub { return "I'm a Hash -" . join ',', map { sprintf '%s=>%s', $_, $_[1]->{$_} } keys %{ $_[1] }; },
        },
        'ARRAY' => {
            run => sub { return "I'm a Array - " . join ',', @{ $_[1] } },
        },
    ],
);

=pod

    my $simple_parser = t::odea::Test->new( parser => $parser )->parser;

    $simple_parser->parse_string;
    $simple_parser->parse_file;_

=cut

1;
