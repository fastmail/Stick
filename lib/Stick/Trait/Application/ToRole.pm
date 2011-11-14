package Stick::Trait::Application::ToRole;
{
  $Stick::Trait::Application::ToRole::VERSION = '0.308';
}

use strict;
use warnings;

use namespace::autoclean;
use Moose::Role;

around apply => sub {
    my $orig  = shift;
    my $self  = shift;
    my $role1 = shift;
    my $role2 = shift;

    $role2 = Moose::Util::MetaRole::apply_metaroles(
      for            => $role2,
      role_metaroles => {
        role                 => [ 'Stick::Trait::Role'],
        application_to_class => [ 'Stick::Trait::Application::ToClass' ],
        application_to_role  => [ 'Stick::Trait::Application::ToRole' ],
      },
    );

    $self->$orig( $role1, $role2 );
};

1;

__END__
=pod

=head1 NAME

Stick::Trait::Application::ToRole

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

