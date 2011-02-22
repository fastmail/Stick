package Stick::Role::Routable::AutoInstance;
use Moose::Role;

use Stick::WrappedMethod;

use namespace::autoclean;

sub _instance_subroute {
  my ($self, $path) = @_;

  my $meta = $self->meta;

  return unless Moose::Util::does_role($meta, 'Stick::Publisher::Role::CanQueryPublished');

  my $next = $path->[0];

  return unless my @methods = $meta->methods_published_under_path($next);

  shift @$path;

  my %map = map {; $_->http_method . '_method' => $_ } @methods;

  return Stick::WrappedMethod->new({
    invocant => $self,
    %map,
  });
}

1;
