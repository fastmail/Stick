package Stick::Role::Collection::HasFilters;
use Moose::Role;
use MooseX::Types::Moose qw(ArrayRef CodeRef);

# filters return true or false
# an item is in the collection only if *all* filters return true
# replace this with a boolean tree structure later on - MJD 20110816
has filters => (
  is => 'ro',
  isa => ArrayRef[CodeRef],
  default => sub { [] },
);

around items => sub {
  my ($orig, $self, @args) = @_;
  my $items = $self->$orig(@args);
  return [ grep $self->_item_in_collection($_), @$items ];
};

sub _item_in_collection {
  my ($self, $item) = @_;
  $_->($item) || return for @{$self->filters};
  return 1;
}

1;

