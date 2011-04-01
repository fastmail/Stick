package PTest::NonproductiveEI;
use Moose;
use Moose::Util::TypeConstraints;

with(
  'Stick::Role::PublicResource',
  'Stick::Role::Routable',
  'Stick::Role::Routable::AutoInstance',
  'Stick::Role::Routable::ClassAndInstance',
);

has productive => (
  is => 'ro',
  isa => 'Int',
  required => 1,
);

sub _class_subroute {
  die "How did I get here?\n";
}

sub _extra_instance_subroute {
  my ($self, $path, $npr_ok) = @_;
  my ($first) = @$path;
  $$npr_ok = 1 if $first eq "ok";
  @$path = () if $self->productive;
  return PTest::Nonproductive->new({ productive => 1 });
}

1;
