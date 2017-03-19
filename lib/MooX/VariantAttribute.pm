package MooX::VariantAttribute;

use strict;
use warnings;
use Carp qw/croak/;
use Scalar::Util qw/blessed/;
use MooX::ReturnModifiers;
our $VERSION = '0.03';

sub import {
    my ( $package, @import ) = @_;
    
    my $target = caller;
    my %modifiers = return_modifiers($target, [qw/has around with/]);

    my $variant = sub {
        my ($name, %spec) = @_;
       
        $modifiers{has}->(
            $name => _construct_attribute($name, %spec)
        );

    };

    $target->can('_given_when') or $modifiers{with}->( 'MooX::VariantAttribute::Role' );

    { no strict 'refs'; *{"${target}::variant"} = $variant;}

    return 1;
}

sub _construct_attribute {
    my ($name, %spec) = @_;

    my $trigger = sub {
        return $_[0]->_given_when($_[1], $spec{given}, $spec{when}, $name);
    };

    return (
        is => $spec{is} ? $spec{is} : 'rw',
        trigger => $trigger,
    );
}

1;

__END__

=head1 NAME

MooX::VariantAttribute - a щ（ﾟДﾟщ）Attribute...

=head1 VERSION

Version 0.03

=cut

=head1 SYNOPSIS

    package Backwards::World;
    use Moo;
    use MooX::VariantAttribute;
    use Type::Standards qw/Object Str/;

    variant parser => (
        given => Object,
        when => [
            'Test::Parser::One' => {
                alias => {
                    parse_string => 'parse',
                    # parse_file exists 
                },
            },
            'Random::Parser::Two' => {
                alias => {
                    # parse_string exists
                    parse_file   => 'parse_from_file', 
                },
            },
            'Another::Parser::Three' => {
                alias => { 
                    parse_string => 'meth_one',
                    parse_file   => 'meth_two', 
                },
            },
        ],
    );

    variant string => (
        given => Str,
        when => [
            'one' => { 
                run => sub { return "$_[2] - cold, cold, cold inside" },
            },
            'two' => {
                run => sub { return "$_[2] - don't look at me that way"; },
            },
            'three' => {
                run => sub { return "$_[2] - how hard will i fall if I live a double life"; },
            },
        ],
    );

    variant refs => (
        given => sub { ref $_[1] or ref \$_[1] }, 
        when => [
            'SCALAR' => { 
                run => sub { 
                    return sprintf "refs returned - %s - %s", $_[1], $_[2]; 
                },
            },
            'HASH' => {
                run => sub { 
                    return sprintf "refs returned - %s - %s", 
                        $_[1], (join(',', map { sprintf '%s=>%s', $_, $_[2]->{$_} } keys %{ $_[2] })); 
                },
            },
            'ARRAY' => {
                run => sub { 
                    return sprintf "refs returned - %s - %s", $_[1], join(',', @{ $_[2] }) 
                },
            },
        ],
    );

=head1 Description


=head2 variant

=head1 AUTHOR

Robert Acock, C<< <thisusedtobeanemail at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-moox-variantattribute at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MooX-VariantAttribute>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc MooX::VariantAttribute


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=MooX-VariantAttribute>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/MooX-VariantAttribute>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/MooX-VariantAttribute>

=item * Search CPAN

L<http://search.cpan.org/dist/MooX-VariantAttribute/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2017 Robert Acock.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1; # End of MooX::VariantAttribute
