package MooX::VariantAttribute::Role;

use Moo::Role;
use Scalar::Util qw/blessed/;
use Carp qw/croak/;

has variant_last_value => (
    is      => 'rw',
    lazy    => 1,
    default => sub { {} },
);

sub _given_when {
    my ($self) = shift;
    my ( $set, $given, $when, $attr ) = @_;

    my $find = $self->_find_from_given(@_);

    return undef if $self->variant_last_value->{$attr}
      and $self->variant_last_value->{$attr} =~ m/^$find$/;
    
    if ( my $found = $when->{$find} ) {
        if ( $found->{alias} ) {
            for my $alias ( keys %{ $found->{alias} } ) {
                next if $set->can($alias);
                my $actual = $found->{alias}->{$alias};
                {
                    no strict 'refs';
                    *{"${find}::${alias}"} = sub { goto &{"${find}::${actual}"} };
                }
            }
        }

        $found->{run} and $set = $found->{run}->( $self, $set );

        $self->variant_last_value->{$attr} =  blessed $set // $set;
        return $self->$attr($set);
    }

    croak sprintf 'Could not find - %s - in when spec for attribute - %s',
      $set, $attr;
}

sub _find_from_given {
    my ( $self, $set, $given, $when ) = @_;

    my $ref_given = ref $given;
    if ( $ref_given eq 'Type::Tiny' ) {
        my $display_name = $given->display_name;
        $display_name eq 'Object' and $given->($set) and return blessed $set;
        $display_name eq 'Str' and return $given->($set);
    }
    elsif ( $ref_given eq 'CODE' ) {
        return $given->( $self, $set );
    }

    return $set;
}

1;
