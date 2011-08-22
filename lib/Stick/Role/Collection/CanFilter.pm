package Stick::Role::Collection::CanFilter;
use Moose::Role;

with ('Stick::Role::Collection::HasFilters');
sub filter {
  my ($self, @filters) = @_;

  $self->meta->new({
    owner => $self,
    filters => [ @filters ],
  });
}

1;
