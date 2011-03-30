package PTest::Nonproductive;
use Moose;
use Moose::Util::TypeConstraints;

with(
#  'PTest::Role::PublishedClass',             # gets us the published
  'Stick::Role::PublicResource',
  'Stick::Role::Routable',
);

has productive => (
  is => 'ro',
  isa => 'Int',
  required => 1,
);

sub _subroute {
  my ($self, $path, $npr_ok) = @_;
  my ($first) = @$path;
  $$npr_ok = 1 if $first eq "ok";
  @$path = () if $self->productive;
  return PTest::Nonproductive->new({ productive => 1 });
}

1;
