package Stick::Role::Collection::CanFilter;
use Moose::Role;

with ('Stick::Role::Collection::HasFilters');

sub filter {
  my ($self, @filters) = @_;

  $self->meta->new_object(
    owner => $self->owner,
    item_array => $self->item_array,
    filters => [ @{ $self->filters }, @filters ],
  );
}

1;
