package Stick::Role::PublicResource::GetSelf;
# ABSTRACT: An object for which an HTTP GET method returns the object itself
use Moose::Role;

use Stick::Error;

with(
  'Stick::Role::PublicResource',
);

use namespace::autoclean;

sub resource_get { return $_[0] }

1;
