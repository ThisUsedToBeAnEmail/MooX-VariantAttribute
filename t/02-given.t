use Moonshine::Test qw/:all/;

use t::odea::Test;

my $test = t::odea::Test->new();

my $scalar = 'Hey simple';

my $string = $test->refs($scalar);

diag explain $string;

sunrise();
