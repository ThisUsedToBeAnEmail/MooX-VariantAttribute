#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'MooX::VariantAttribute' ) || print "Bail out!\n";
}

diag( "Testing MooX::VariantAttribute $MooX::VariantAttribute::VERSION, Perl $], $^X" );
