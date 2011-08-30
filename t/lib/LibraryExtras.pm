package t::lib::LibraryExtras;
use Moose::Role;
use Carp qw(confess croak);

sub add {
  my ($self, $arg) = @_;
  $arg = $arg->{attributes} or croak "No 'attributes' hash";
  $arg = $arg->{new_item} or croak "No 'new_item' attribute";
  $self->owner->add_this_book($arg);
}

1;
