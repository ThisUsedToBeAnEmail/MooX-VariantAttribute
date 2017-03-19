use Test::More;

use lib '.';

use t::odea::Test;

my $attribute = t::odea::Test->new( string => 'one' );

is $attribute->string, 'one - cold, cold, cold inside';

ok($attribute->string('two'));

is $attribute->string, 'two - don\'t look at me that way';

ok($attribute->string('three'));

is $attribute->string, 'three - how hard will i fall if I live a double life';

ok($attribute->refs($attribute->string));

is $attribute->refs, 'refs returned - SCALAR - three - how hard will i fall if I live a double life';

{
    package Backwards::World;
    use Moo;
    use MooX::VariantAttribute;
    use Types::Standard qw/Any/;

    variant hello => (
        given => Any,
        when => [
            { one => 'two' } => {
                run => sub { return keys %{ $_[2] } },
            },
            { three => 'four' } => {
                run => sub { return values %{ $_[2] } },
            },
            [ qw/five six/ ] => {
                run => sub { return $_[2]->[1] },
            },
            seven => {
                run => sub { return $_[0]->hello({ one => 'two' }) },
            }
        ],
    );
}

my $object = Backwards::World->new( );

is $object->hello({ one => 'two' }), 'one';
is $object->hello, 'one';

is $object->hello({ three => 'four' }), 'four';
is $object->hello, 'four';

is $object->hello([ qw/five six/ ]), 'six';
is $object->hello, 'six';

is $object->hello('seven'), 'one';
is $object->hello, 'one';

{
    package Backwards::World::ro;
    use Moo;
    use MooX::VariantAttribute;
    use Types::Standard qw/Any/;

    variant hello => (
        given => Any,
        when => [
            { one => 'two' } => {
                run => sub { return keys %{ $_[2] } },
            },
        ],
    );
}

my $object2 = Backwards::World::ro->new( hello => { one => 'two' } );
is $object->hello, 'one';

done_testing();
