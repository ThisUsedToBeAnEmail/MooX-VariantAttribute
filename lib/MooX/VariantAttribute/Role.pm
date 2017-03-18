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

    return if $self->_variant_last_value($attr, 'set', $set);

    my $find = $self->_find_from_given(@_);

    return if $self->_variant_last_value($attr, 'find', $find);
    
    $self->variant_last_value->{$attr}->{find} = $find;
    
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

        $found->{run} and $set = $found->{run}->( $self, $set, $found );

        $self->variant_last_value->{$attr}->{set} = $set;

        return $self->$attr($set);
    }

    croak sprintf 'Could not find - %s - in when spec for attribute - %s',
      $set, $attr;
}

sub _variant_last_value {
    my ($self, $attr, $value, $set) = @_;

    return undef unless ref \$set eq 'SCALAR';
    return undef unless $self->variant_last_value->{$attr};
    return 1 if $self->variant_last_value->{$attr}->{$value} =~ m/^$set$/;
    return undef; 
}

sub _find_from_given {
    my ( $self, $set, $given, $when ) = @_;

    my $ref_given = ref $given;
    if ( $ref_given eq 'Type::Tiny' ) {
        my $display_name = $given->display_name;
        $given->($set);
        $display_name eq 'Object' and return blessed $set;
        return $set;
    }
    elsif ( $ref_given eq 'CODE' ) {
        my $val = $given->( $self, $set );
        return $val;
    }

    return $set;
}

1;
