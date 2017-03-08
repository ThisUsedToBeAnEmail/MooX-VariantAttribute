use Moonshine::Test qw/:all/;

use t::odea::Test;

package Test::Parser::One;

use Moo;

sub parse {
    return 'parse string';
}

sub parse_file {
    return 'parse file';
}

package Random::Parser::Two;

use Moo;

sub parse_string {
    return 'parse string';
}

sub parse_from_file {
    return 'parse file';
}

package Another::Parser::Three;

use Moo;

sub meth_one {
    return 'parse string';
}

sub meth_two {
    return 'parse file';
}

package main;

my $t1 = Test::Parser::One->new();

moon_test(
    name => 'Test::Parser::One'
    build => {
        class => 't::odea::Test',
        args  => {
            parser => $t1,
        }
    },
    instructions => [
        {
            test => 'scalar',
            func => 'parse_string',
            expected => 'parse string',
        }
        {
            test => 'scalar',
            func => 'parse_file',
            expected => 'parse file',
        }
    ],
);

my $t2 = Random::Parser::Two->new();

moon_test(
    name => 'Random::Parser::Two'
    build => {
        class => 't::odea::Test',
        args  => {
            parser => $t2,
        }
    },
    instructions => [
        {
            test => 'scalar',
            func => 'parse_string',
            expected => 'parse string',
        }
        {
            test => 'scalar',
            func => 'parse_file',
            expected => 'parse file',
        }
    ],
);

my $t3 = Another::Parser::Three->new();

moon_test(
    name => 'Another::Parser::Three',
    build => {
        class => 't::odea::Test',
        args  => {
            parser => $t3,
        }
    },
    instructions => [
        {
            test => 'scalar',
            func => 'parse_string',
            expected => 'parse string',
        },
        {
            test => 'scalar',
            func => 'parse_file',
            expected => 'parse file',
        }
    ],
);

sunrise();
