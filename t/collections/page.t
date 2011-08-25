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

sub ids {
  my %id = map { $_->id => 1 } @_;
  return keys %id;
}

test "page" => sub {
  my ($self) = @_;
  my @r;

  my $lib = $self->fresh_library;
  is($lib->book_collection->pages, 0);

  note "About to check page counts";
  for (1..30) {
    push @r, my $book = $lib->add_this_book({ new_item => Book->new });
    is($lib->book_collection->pages,     int($_ / 20))
      if $_ % 20 == 0;
    is($lib->book_collection->pages, 1 + int($_ / 20))
      if $_ % 20 != 0;
  };

  note "About to check page sizes";
  {
    my $page1 = $lib->book_collection->page({ page => 1 });
    my $page2 = $lib->book_collection->page({ page => 2 });
    my $page3 = $lib->book_collection->page({ page => 3 });

    is(@$page1, 20, "page 1 has 20/30 items");
    is(@$page2, 10, "page 2 has 10/30 items");
    is(@$page3,  0, "page 3 is empty");

    is(ids(@$page1, @$page2), ids(@r), "pages 1+2 have all 30 items");
  }

  note "About to check pages with alternative size";
  {
    for (1..4) {
      my $page = $lib->book_collection->page({ page => $_, pagesize => 7 });
      is(@$page, 7, "page $_ has 7/7 items");
    }
    my $page = $lib->book_collection->page({ page => 5, pagesize => 7 });
    is(@$page, 2, "page 5 has 2/7 items");
  }

  note "About to check pages with alternative default size";
  {
    my $c = $lib->book_collection;
    $c->default_page_size(7);
    for (1..4) {
      my $page = $c->page({ page => $_ });
      is(@$page, 7, "page $_ has 7/7 items");
    }
    my $page = $c->page({ page => 5 });
    is(@$page, 2, "page 5 has 2/7 items");
  }

};

run_me;
done_testing;

1;
