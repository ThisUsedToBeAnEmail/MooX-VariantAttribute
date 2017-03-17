package t::odea::Test;

use Moo;
use MooX::VariantAttribute;

variant parser => (
    is  => 'ro',
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

variant refs => (
    is  => 'ro',
    given => sub { ref $_[0] }, 
    when => [
        'SCALAR' => { 
            run => sub { return "I'm a Scalar - $_[0]" },
        },
        'HASH' => {
            run => sub { return "I'm a Hash -" . join ',', map { sprintf '%s=>%s', $_, $_[0]->{$_} } keys $_[0]; },
        },
        'ARRAY' => {
            run => sub { return "I'm a Array - " join ',', @{ $_[0] } },
        },
    ],
);

=pod

    my $simple_parser = t::odea::Test->new( parser => $parser )->parser;

    $simple_parser->parse_string;
    $simple_parser->parse_file;_

=cut

1;
