package Stick::Role::Routable::AutoInstance;
{
  $Stick::Role::Routable::AutoInstance::VERSION = '0.304';
}
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

__END__
=pod

=head1 NAME

Stick::Role::Routable::AutoInstance - A class that provides routes to all its published methods

=head1 VERSION

version 0.304

=head1 AUTHOR

Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

