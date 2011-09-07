package Stick::Role::Collection::CanFilter;
use Moose::Role;

with ('Stick::Role::Collection::HasFilters');

sub filter {
  my ($self, @filters) = @_;

  $self->meta->new_object(
    owner => $self,
    item_array => "items",
    filters => [ @filters ],
  );
}

1;
