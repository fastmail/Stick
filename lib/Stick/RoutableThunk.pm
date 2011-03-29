package Stick::RoutableThunk;
use Moose;

use namespace::autoclean;

with('MooseX::OneArgNew' => {
  type => 'CodeRef',
  init_arg => 'code',
});

has code => (
  is  => 'ro',
  isa => 'CodeRef',
  required => 1,
);

sub _subroute {
  my ($self, $path, $npr_ok) = @_;
  $$npr_ok = 1;
  return $self->code->();
}

1;
