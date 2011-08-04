#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Test::Routine;
use Test::Routine::Util -all;

use t::lib::Library;

sub fresh_library {
  return t::lib::Library->new();
}

test "library gc" => sub {
  my ($self) = @_;
  my $lib = $self->fresh_library();
  my $bc = $lib->book_collection();
  undef $lib;
  ok($bc->owner, "was ledger prematurely garbage-collected?");
};

run_me;
done_testing;
