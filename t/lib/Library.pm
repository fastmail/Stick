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
    item_roles => ['t::lib::Book'],
#    is => 'ro',
 });

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

