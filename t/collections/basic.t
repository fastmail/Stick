#!/usr/bin/env perl
use strict;
use warnings;
use Test::Deep qw(array_each cmp_deeply code);
use Test::More;
use Test::Routine;
use Test::Routine::Util -all;

use t::lib::Library;
use t::lib::Book;

sub fresh_library {
  return t::lib::Library->new();
}

test "owner methods" => sub {
  my ($self) = @_;
  my $books;
  my $lib = $self->fresh_library();

  ok($lib->book_collection->does("Stick::Role::Collection"));
  $books = $lib->book_array();
  is(@$books, 0, "empty array");

  $lib->add_this_book({ new_item => Book->new });
  $books = $lib->book_array();
  is(@$books, 1, "now has a book");
};

sub try_methods {
  my ($self, $coll, $x) = @_;

  is($coll->count, $x, "count == $x");
  { my @books = $coll->all;
    is(@books, $x, "count(all) == $x");
    cmp_deeply(\@books, array_each(code(sub { $_[0]->does("t::lib::Book") })),
               "Library constains nothing but books");
  }
  { my $books = $coll->items;
    is(@$books, $x, "count(all) == $x");
    cmp_deeply($books, array_each(code(sub { $_[0]->does("t::lib::Book") })),
               "Library constains nothing but books");
  }
}

# for page-related methods, see page.t
# for sort-related methods, see sort.t
# for search and subset methods, see search.t
test collection_methods => sub {
  my ($self) = @_;
  my $lib = $self->fresh_library();
  my $bc = $lib->book_collection;
  is($bc->owner, $lib, "owner");

  $self->try_methods($bc, 0);

  # In general, we will have a more complicated object specification than this
  # Since the test is in a non-web context we can pass the new object directly.
  # - mjd 2011-08-25
  $lib->add_this_book({ new_item => Book->new });
  $self->try_methods($bc, 1);

  $bc->add({ attributes => { new_item => Book->new }});
  $self->try_methods($bc, 2);
};

run_me;
done_testing;
