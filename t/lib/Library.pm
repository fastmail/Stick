package t::lib::Library;
# ABSTRACT: Class for testing HasCollection
use Moose;
use Moose::Util::TypeConstraints qw(role_type);
use MooseX::Types::Moose qw(HashRef);

has by_id => (
  is => 'ro',
  isa => HashRef [ role_type('t::lib::Book') ],
  default => sub { {} },
  traits => [ 'Hash' ],
  handles => {
    store_book => 'set',
  },
);

with (
  'Stick::Role::HasCollection' => {
    item => 'book',
    collection_roles => [ 'Stick::Role::Collection::Pageable',
                          [ 'Stick::Role::Collection::Mutable' =>  "Mutable" =>
                              { add_this_item => 'add_this_book',
                                item_roles => ['t::lib::Book'], }
                             ],
                          'Stick::Role::Collection::CanFilter',
                         ]});

sub book_array {
  my ($self) = @_;
  return [ values %{$self->by_id} ];
}

sub add_this_book {
  my ($self, $book) = @_;
  $self->store_book($book->id, $book);
}

package Book;
use Moose;
with 't::lib::Book';

1;

