package t::odea::Test2;

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

sub _trigger_parser { };

=pod

    my $simple_parser = t::odea::Test->new( parser => $parser )->parser;

    $simple_parser->parse_string;
    $simple_parser->parse_file;_

=cut

1;