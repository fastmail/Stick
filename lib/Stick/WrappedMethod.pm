package Stick::WrappedMethod;
use Moose;

with(
  'Stick::Role::PublicResource',
);

use namespace::autoclean;

has invocant => (
  is  => 'ro',
  isa => 'Defined',
  required => 1,
);

my @methods = qw(get put post delete);

require Moose::Meta::Method;

has [ map {; "$_\_method" } @methods ] => (
  is  => 'ro',
  isa => 'Moose::Meta::Method',
);

for my $method (@methods) {
  Sub::Install::install_sub({
    as   => "resource_$method",
    code => sub {
      my ($self, $arg) = @_;
      my $proxy_name   = "$method\_method";
      Moonpig::X->throw("bad http method")
        unless my $proxy_method = $self->$proxy_name;
      return $proxy_method->($self->invocant, $arg);
    },
  });
}

1;
