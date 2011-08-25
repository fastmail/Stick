package Stick::Role::Routable::AutoInstance;
# ABSTRACT: A class that provides routes to all its published methods
use Moose::Role;

use Stick::WrappedMethod;

use namespace::autoclean;

sub _instance_subroute {
  my ($self, $path, $ndr) = @_;

  if ($self->can('_extra_instance_subroute')) {
    my $res = $self->_extra_instance_subroute($path, $ndr);
    return $res if $res;
  }

  my $meta = $self->meta;

  return unless Moose::Util::does_role($meta, 'Stick::Trait::Class::CanQueryPublished');

  my $next = $path->[0] || "";

  if (my @methods = $meta->methods_published_under_path($next)) {
    shift @$path;

    my %map = map {; $_->http_method . '_method' => $_ } @methods;

    return Stick::WrappedMethod->new({
      invocant => $self,
      %map,
    });
  }

  if (my $attr = $meta->attribute_published_under_path($next)) {
    shift @$path;

    return Stick::WrappedMethod->new({
      invocant   => $self,
      get_method => $meta->find_method_by_name($attr->get_read_method),
    });
  }

  # no methods, no attributes, no joy -- rjbs, 2011-02-24
  return;
}

1;
