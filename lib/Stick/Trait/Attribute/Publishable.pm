package Stick::Trait::Attribute::Publishable;
use Moose::Role;

use Moose::Util::TypeConstraints qw(enum);

use namespace::autoclean;

has publish_as => (
  is  => 'ro',
  isa  => 'Str',
  lazy => 1,
  default => sub { $_[0]->name },
);

has publish_is => (
  is  => 'ro',

  # XXX: Eventually we can have "rw" for PUT setters -- rjbs, 2011-02-25
  isa => enum([ qw(ro ro) ]),
);

1;
