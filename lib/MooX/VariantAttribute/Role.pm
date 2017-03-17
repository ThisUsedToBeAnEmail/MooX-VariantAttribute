package MooX::VariantAttribute::Role;

use Moo::Role;
use Scalar::Util qw/blessed/;

sub _when_variant {
	my ($self, $set, $given, $when) = @_;

    my $find = $given->display_name eq 'Object' ? blessed $set : $set;
    
    if ( my $found = $when->{$find} ) {
		if ( $found->{alias} ) {
			for my $alias (keys %{$found->{alias}}) {
				next if $set->can($alias);
				my $actual = $found->{alias}->{$alias};
				{
					no strict 'refs';
					*{"${find}::${alias}"} = sub { goto &{"${find}::${actual}"} };
				}
			}
		}
	
    	$found->{run} and $set = $found->{run}->($self, $set);
	}        

    return $set;
}

1;
