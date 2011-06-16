package Stick::Role::Routable::ClassAndInstance;
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
