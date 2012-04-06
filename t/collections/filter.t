#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Test::Routine;
use Test::Routine::Util '-all';

use Stick::Util qw(ppack);

use t::lib::Library;
use t::lib::Book;

has library => (
    is => 'ro',
    default => sub { $_[0]->fresh_library(4) },
);

sub all (&@) {
  my $p = shift;
  for (@_) { return unless $p->($_) }
  return 1;
}

sub fresh_library {
  my ($self, $n) = @_;
  $n ||= 0;
  my $lib = t::lib::Library->new();
  for (1 .. $n) {
    $lib->add_this_book($self->next_book());
  }
  die "Couldn't make library with $n books"
      unless @{$lib->book_array} == $n;
  return $lib;
}

test "filter" => sub {
  my ($self) = @_;
  my $lib = $self->library;
  my $books = $lib->book_collection;
  ok($books->does("Stick::Role::Collection::CanFilter"));
  my $hemingway = $books->filter(sub { $_->author eq "Hemingway" });
  ok($hemingway->does("Stick::Role::Collection"));
  is($hemingway->count, 2);
  for my $book (@{$hemingway->items}) {
    is ($book->author, "Hemingway");
  }
  for my $book ($hemingway->all) {
    is ($book->author, "Hemingway");
  }
};

test "subfilter" => sub {
  my ($self) = @_;
  my $lib = $self->library;
  my $books = $lib->book_collection;
  my $fat_russian = $books->filter(sub { $_->length > 200 })
      ->filter(sub { $_->author eq "Dostoevsky" });
  ok($fat_russian->does("Stick::Role::Collection"));
  is($fat_russian->count, 1);
};

run_me;
done_testing;

sub next_book {
  my ($self) = @_;
  my @lines;
  push @lines, $_ while defined($_ = <DATA>) && /\S/;
  chomp @lines;
  my %items = map split(/:\s+/, $_, 2), @lines;
  return Book->new(\%items);
}

__DATA__
author: Hemingway
title: The Sun Also Rises
length: 120

author: Dostoevsky
title: Crime and Punishment
length: 457

author: Dickens
title: Great Expectations
length: 382

author: Hemingway
title: For Whom the Bell Tolls
length: 183
