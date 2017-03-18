use Test::More;

{
    package One::Two::Three;

    use Moo;
    use MooX::VariantAttribute;
    use Types::Standard qw/Str/;

    variant switch => (
        given => Str,
        when => [
            one => { run => sub { return 'easy' } },
            two => { run => sub { return [qw/thinking to/] } },
            three => { run => sub { return { need => 'to' } } },
        ],
    );

}

my $obj = One::Two::Three->new;

is $obj->switch('one'), 'easy', "Switch one is easy";
is_deeply $obj->switch('two'), [qw/thinking to/], "Switch two [thinking to]";
is_deeply $obj->switch('three'), { need => 'to' }, "switch three { need => to }"; 

done_testing();
