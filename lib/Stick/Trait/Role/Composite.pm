package Stick::Trait::Role::Composite;
{
  $Stick::Trait::Role::Composite::VERSION = '0.308';
}
use Moose::Role;

use Moose::Util::MetaRole;
use Moose::Util qw(does_role);

use namespace::autoclean;

with 'Stick::Trait::Role';

around apply_params => sub {
    my $orig = shift;
    my $self = shift;

    $self->$orig(@_);

    $self = Moose::Util::MetaRole::apply_metaroles(
        for            => $self,
        role_metaroles => {
            application_to_class => [ 'Stick::Trait::Application::ToClass' ],
            application_to_role  => [ 'Stick::Trait::Application::ToRole'  ],
        },
    );

    return $self;
};

1;

__END__
=pod

=head1 NAME

Stick::Trait::Role::Composite

=head1 VERSION

version 0.308

=head1 AUTHORS

=over 4

=item *

Ricardo Signes <rjbs@cpan.org>

=item *

Mark Jason Dominus <mjd@cpan.org>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Ricardo Signes, Mark Jason Dominus.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

