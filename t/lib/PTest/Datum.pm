package PTest::Datum;
use Moose;
use Stick::Publisher;

with(
  'Stick::Role::Routable',
  'Stick::Role::Routable::ClassAndInstance',
  'Stick::Role::Routable::AutoInstance',
);

use namespace::autoclean;

has not_pub => (
  is => 'rw',
  default => 123,
);

has pub_ro => (
  is => 'rw',
  required   => 1,
  publish_is => 'ro',
);

sub _class_subroute { confess 'unimplemented' }

1;
