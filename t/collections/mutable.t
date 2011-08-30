#!/usr/bin/env perl
use strict;
use warnings;
use Test::Fatal;
use Test::More;
use Test::Routine;
use Test::Routine::Util -all;

use t::lib::Library;
use t::lib::Book;

sub fresh_library {
  return t::lib::Library->new();
}

test "add_this_item" => sub {
  my ($self) = @_;
  my $lib = $self->fresh_library();
  my $book = Book->new();
  $lib->add_this_book($book);
  my $books = $lib->book_collection;
  ok($books->does("Stick::Role::Collection"));
  is($books->count, 1);
  is($lib->book_array->[0], $book);
  is($books->items->[0], $book);
};

test "add" => sub {
  my ($self) = @_;
  my $lib = $self->fresh_library();
  my $book = Book->new();
  my $books = $lib->book_collection;
  $books->add({ attributes => { new_item => $book }});
  is($books->count, 1);
  is($lib->book_array->[0], $book);
  is($books->items->[0], $book);
};

run_me;
done_testing;
