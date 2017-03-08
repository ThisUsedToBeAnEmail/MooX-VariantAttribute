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

my %test_args = (
    'Test::Parser::One'   => Test::Parser::One->new(),
    'Random::Parser::Two' => Random::Parser::Two->new(),
    'Another::Parser::Three' => Another::Parser::Three->new(),
);

moon_test(
    name => 'Test::Parser::One' ,
    build => {
        class => 't::odea::Test',
        args  => {
            parser => $test_args{'Test::Parser::One'},
        }
    },
    instructions => [
        {
            test => 'obj',
            func => 'parser',
            expected => 'Test::Parser::One',
            subtest => [
                {
                    test => 'scalar',
                    func => 'parse',
                    expected => 'parse string',
                },
                {
                    test => 'scalar',
                    func => 'parse_file',
                    expected => 'parse file',
                }
            ],
        }
    ],
);




for (keys %test_args) {
    moon_test(
        name => $_,
        build => {
            class => 't::odea::Test',
            args  => {
                parser => $test_args{$_},
            }
        },
        instructions => [
            {
                test => 'obj',
                func => 'parser',
                expected => $_,
                subtest => [
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
            }
        ],
    );
}

sunrise();
