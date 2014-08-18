package Stick::Entity::Nop;

use Moose;

has reason => (
  is  => 'ro',
  isa => 'Str',
  default => 'no action required',
);

sub STICK_PACK {
  return { type => 'stick.nop' };
}

1;
