package Stick::Role::Collection::Pageable;

use strict;
use warnings;

use Carp 'confess';
use List::Util qw(min);
use MooseX::Role::Parameterized;
use MooseX::Types::Moose qw(Maybe);
use Stick::Types qw(PositiveInt);
use POSIX qw(ceil);
use Scalar::Util qw(blessed);

require Stick::Publisher;
use Stick::Publisher::Publish;

with ('Stick::Role::Collection::Sortable' => { sort_attr => 'guid' });
# Sortable will provide the 'publish' utilities

parameter pagesize => (
  is => 'rw',
  isa => PositiveInt,
  default => 20,
);

role {
  my ($p, %args) = @_;

  sub publish;

  require Stick::Role::Routable::AutoInstance;

  BEGIN {
    require Carp;
    Carp->import(qw(carp confess croak));
  }

  has default_page_size => (
    is => 'rw',
    isa => PositiveInt,
    default => $p->pagesize,
  );

  # Page numbers start at 1.
  # TODO: .../collection/page/3 doesn't work yet
  publish page => { pagesize => Maybe[PositiveInt],
                    page => PositiveInt,
                  } => sub {
    my ($self, $args) = @_;
    my $pagesize = $args->{pagesize} || $self->default_page_size();
    my $pagenum = $args->{page};
    my $items = $self->items_sorted;
    my $start = ($pagenum-1) * $pagesize;
    my $end = min($start+$pagesize-1, $#$items);
    return [ @{$items}[$start .. $end] ];
  };

  # If there are 3 pages, they are numbered 1, 2, 3.
  publish pages => { pagesize => Maybe[PositiveInt],
                   } => sub {
    my ($self, $args) = @_;
    my $pagesize = $args->{pagesize} || $self->default_page_size();
    return ceil($self->count / $pagesize);
  };
};

1;
