package MooX::VariantAttribute::Role;

use Moo::Role;
use Carp qw/croak/;
use Scalar::Util qw/blessed refaddr reftype/;

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
   
    $self->variant_last_value->{$attr}->{find} = $find;
    
    my @when = @{ $when };
    while (@when) {
        my $check = shift @when;
        my $found = shift @when;
        if ( _struct_the_same($check, $find) ) {
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

            $found->{run} and $set = $found->{run}->( $self, $set, $find );

            $self->variant_last_value->{$attr}->{set} = $set;

            return $self->$attr($set);
        }
    }

    croak sprintf 'Could not find - %s - in when spec for attribute - %s',
      $set, $attr;
}

sub _variant_last_value {
    my ($self, $attr, $value, $set) = @_;

    return undef unless $self->variant_last_value->{$attr};
    return _ref_the_same($self->variant_last_value->{$attr}->{$value}, $set);
}

sub _ref_the_same {
    my ($stored, $passed) = @_;

    if ( ref $passed and ref $stored ) {
        return refaddr($stored) == refaddr($passed) ? 1 : undef;
    } 
    
    return ($stored =~ m/^$passed$/) ? 1 : undef;
}

sub _struct_the_same {
    my ($stored, $passed) = @_;
    
    my $stored_ref = reftype($stored) || reftype(\$stored);
    my $passed_ref = reftype($passed) || reftype(\$passed);
    $stored_ref eq $passed_ref or return undef;
     
    if ( $stored_ref eq 'SCALAR') {
          return ($stored =~ m/^$passed$/) ? 1 : undef;
    } elsif ($stored_ref eq 'HASH') {
        for (keys %{$passed}) {
            $stored->{$_} or return undef;
            _struct_the_same($stored->{$_}, $passed->{$_}) or return undef;    
        }
        return 1;
    } elsif ($stored_ref eq 'ARRAY') {
        for ( scalar @{$passed} - 1 ) {
            _struct_the_same($stored->[$_], $passed->[$_]) or return undef;
        }
        return 1;
    }

    return 1;
}

sub _find_from_given {
    my ( $self, $set, $given, $when ) = @_;

    my $ref_given = ref $given;
    if ( $ref_given eq 'Type::Tiny' ) {
        my $display_name = $given->display_name;
        $set = $given->($set);
        $display_name eq 'Object' and return ref $set;
        return $set;
    }
    elsif ( $ref_given eq 'CODE' ) {
        my $val = $given->( $self, $set );
        return $val;
    }

    return $set;
}

1;
