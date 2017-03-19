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

done_testing();
