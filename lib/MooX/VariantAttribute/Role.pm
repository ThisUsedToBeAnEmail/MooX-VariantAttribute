package MooX::VariantAttribute::Role;

use Moo::Role;
use Scalar::Util qw/blessed/;

sub _given_when {
	my ($self) = shift;
    my ($set, $given, $when) = @_;
    
    my $find = $self->_find_from_given(@_);

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

sub _find_from_given {
    my ( $self, $set, $given, $when ) = @_;

    if ( ref $given eq 'Type::Tiny' ) {
        my $display_name = $given->display_name;
        $display_name eq 'Object' and return blessed $set;
        $display_name eq 'Str' and return $set; 
    }
    return $set;
}


1;
