package Stick::Role::Routable::ClassAndInstance;
BEGIN {
  $Stick::Role::Routable::ClassAndInstance::VERSION = '0.300';
}
use Moose::Role;

with(
  'Stick::Role::Routable',
);

use namespace::autoclean;

requires '_class_subroute';
requires '_instance_subroute';

sub _subroute {
  my ($invocant, $path, $npr) = @_;

  my $method = blessed $invocant ? '_instance_subroute' : '_class_subroute';

  return $invocant->$method($path, $npr);
}

1;

__END__
=pod

=head1 NAME

Stick::Role::Routable::ClassAndInstance

=head1 VERSION

version 0.300

=head1 AUTHOR

Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

