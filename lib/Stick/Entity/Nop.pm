package Stick::Entity::Nop;
use Moose;

has reason => (
  is  => 'ro',
  isa => 'Str',
  default => 'no action required',
);

sub PRISM_PACK {
  return { type => 'prism.nop' };
}

1;
