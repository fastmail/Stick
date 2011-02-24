package Stick::Role::PublicResource::GetSelf;
use Moose::Role;

use Stick::Error;

with(
  'Stick::Role::PublicResource',
);

use namespace::autoclean;

sub resource_get { return $_[0] }

1;
