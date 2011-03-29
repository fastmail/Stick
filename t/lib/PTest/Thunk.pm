package PTest::Thunk;
use Moose;
use Moose::Util::TypeConstraints;
use Stick::RoutableThunk;

with (qw(Stick::Role::Routable
         Stick::Role::PublicResource));

has _trace => (
  is => 'ro',
  default => sub { [] },
  init_arg => undef,
  reader => 'get_trace',
);

sub trace {
  my ($self, @items) = @_;
  push @{$self->get_trace}, @items;
}

sub _subroute {
  my ($self, $path, $npr_ok) = @_;
  my $first = shift @$path;
  if (@$path == 0) {
    $self->trace($first);
    return $self;
  }

  return Stick::RoutableThunk->new(
    sub {
      $self->trace($first);
      return $self;
    });
}

1;
