use Test::More;

use Types::Standard qw/Str Object/;

{
    package One::Two::Three;

    use Moo;
    with 'MooX::VariantAttribute::Role';
    
}

my $obj = One::Two::Three->new();

my $when = {
    'one' => { 
        run => sub { return "$_[1] - cold, cold, cold inside" },
    },
    'two' => {
        run => sub { return "$_[1] - don't look at me that way"; },
    },
    'three' => {
        run => sub { return "$_[1] - how hard will i fall if I live a double life"; },
    },
};

is $obj->_when_variant('one', Str, $when), 'one - cold, cold, cold inside', 'okay we have one';
is $obj->_when_variant('two', Str, $when), 'two - don\'t look at me that way', 'okay we have two';
is $obj->_when_variant('three', Str, $when), 'three - how hard will i fall if I live a double life', 'okay we have three';

{
    package Random::Parser::Two;

    use Moo;

    sub parse_string {
        return 'parse string';
    }

    sub parse_from_file {
        return 'parse file';
    }
}

my $when2 = {    
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
};

my $parser = Random::Parser::Two->new();
my $parser = $obj->_when_variant($parser, Object, $when2);
is( $parser->parse_file, 'parse file', 'alias' );

done_testing();
