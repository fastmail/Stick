package Stick::Trait::Class::CanQueryPublished;
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

1;
