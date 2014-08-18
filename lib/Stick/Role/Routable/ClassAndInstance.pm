package Stick::Role::Routable::ClassAndInstance;
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
