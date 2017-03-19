use Test::More;

use Types::Standard qw/Str Object/;

{
    package One::Two::Three;

    use Moo;
    with 'MooX::VariantAttribute::Role';    
}

my $obj = One::Two::Three->new;

is (&One::Two::Three::_struct_the_same('hey', 'hey'), 1, 'hey');
is (&One::Two::Three::_struct_the_same('hy', 'hey'), undef, 'hy not hey');

is (&One::Two::Three::_struct_the_same({ one => 'two', three => 'four' }, { one => 'two', three => 'four' }), 1, 'match hash');
is (&One::Two::Three::_struct_the_same({ one => 'two', thee => 'four' }, { one => 'two', three => 'four' }), undef, 'fail hash');

is (&One::Two::Three::_struct_the_same([qw/one two three/], [qw/one two three/]), 1, 'match array');
is (&One::Two::Three::_struct_the_same([qw/one two thee/], [qw/one two three/]), undef, 'fail array');

done_testing();