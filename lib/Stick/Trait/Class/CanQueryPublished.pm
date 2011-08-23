package Stick::Trait::Class::CanQueryPublished;
{
  $Stick::Trait::Class::CanQueryPublished::VERSION = '0.303';
}
use Moose::Role;

sub get_all_published_methods {
  my ($meta) = @_;
  return grep { $_->can('is_published') && $_->is_published }
         $meta->get_all_methods;
}

sub get_all_published_method_names {
  my ($meta) = @_;
  return map { $_->name } $meta->get_all_published_methods;
}

sub methods_published_under_path {
  my ($meta, $path) = @_;

  return grep { $_->path eq $path } $meta->get_all_published_methods;
}

sub get_all_published_attributes {
  my ($meta) = @_;

  return grep { $_->can('publish_is') and defined $_->publish_is }
         $meta->get_all_attributes;
}

sub attribute_published_under_path {
  my ($meta, $path) = @_;

  my @attr = grep { $_->publish_as eq $path }
             $meta->get_all_published_attributes;

  return unless @attr;
  return $attr[0] if @attr == 1;

  confess "bizarrely found multiple attributes with same published name $path";
}

1;

__END__
=pod

=head1 NAME

Stick::Trait::Class::CanQueryPublished

=head1 VERSION

version 0.303

=head1 AUTHOR

Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

