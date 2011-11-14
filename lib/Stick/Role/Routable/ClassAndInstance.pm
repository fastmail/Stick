package Stick::Role::Routable::ClassAndInstance;
{
  $Stick::Role::Routable::ClassAndInstance::VERSION = '0.308';
}
# ABSTRACT: A class with with routing from itself and from its instances
use Moose::Role;

with(
  'Stick::Role::Routable',
);

use namespace::autoclean;

requires '_class_subroute';
requires '_instance_subroute';

sub _subroute {
  my ($invocant, $path, $ndr) = @_;

  my $method = blessed $invocant ? '_instance_subroute' : '_class_subroute';

  return $invocant->$method($path, $ndr);
}

1;

__END__
=pod

=head1 NAME

Stick::Role::Routable::ClassAndInstance - A class with with routing from itself and from its instances

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

