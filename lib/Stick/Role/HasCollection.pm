package Stick::Role::HasCollection;
# ABSTRACT: A class which owns a (routable) collection of objects

use Stick::Types qw(Factory);
use Stick::Util qw(class);
use MooseX::Role::Parameterized;
use MooseX::Types::Moose qw(Str ArrayRef HashRef Defined);
use Moose::Util::TypeConstraints qw(subtype union);

# Name of the sort of thing this collection will contain
# e.g., "refund".
parameter item => (isa => Str, required => 1);
# Plural version of above
parameter items => (isa => Str, lazy => 1,
                    default => sub { $_[0]->item . 's' },
                   );

# The collection itelf will compose these roles
# Good for adding extra constructors or whatever

parameter collection_roles => (
  isa => ArrayRef[union([Str,
                         ArrayRef,
                        ])],
  default => sub { [] },
);

parameter is => (
  isa => subtype(Str, { where => sub { /\Ar[ow]\z/ } }),
  default => 'rw',
);


# method that handles POST requests to this collection
parameter post_action => (
  isa => Str,
  is => 'ro',
  default => 'add',
);

parameter default_sort_key => (
  isa => Str,
  is => 'ro',
  required => 0,
);

# Class name or factory object for the collection itself.
# e.g., "Moonpig::Class::RefundCollection", which will do
#   Moonpig::Role::Collection
parameter factory => (
  isa => Factory,
  lazy => 1,
  default => sub {
    my ($p) = @_;
    require Stick::Role::Collection;

    my $parameters = {
      collection_name => $p->item_collection_name,
      add_this_item => $p->add_this_thing,
      item_array => $p->accessor,
      post_action => $p->post_action,
      default_sort_key => $p->default_sort_key,
    };

    my $c = class([ 'Stick::Role::Collection',
                    $p->item_collection_name, $parameters, ],
                    @{$p->collection_roles},
                 );
    return $c;
  }
);

# Name for the item collection class
# e.g., "RefundCollection";
parameter item_collection_name => (
  isa => Str,
  lazy => 1,
  default => sub {
    my ($p) = @_;
    ucfirst($p->item . "Collection");
  },
);

# Name of parent method that returns an arrayref of the things
# default "thing_array"
parameter accessor => (
  isa => Str,
  lazy => 1,
  default => sub { $_[0]->item . "_array" },
);

# Method name for collection object constructor
# Default: "thing_collection"
parameter constructor => (
  isa => Str,
  lazy => 1,
  default => sub { $_[0]->item . "_collection" },
);

# Names of parent method that inserts a new item
parameter add_this_thing => (
  isa => Str,
  lazy => 1,
  default => sub { "add_this_" . $_[0]->item },
);

role {
  my ($p) = @_;
  my $thing = $p->item;
  my $things = $p->items;
  my $accessor = $p->accessor || "$thing\_array";
  my $constructor = $p->constructor || "$thing\_collection";
  my $add_this_thing = $p->add_this_thing || "add_this_$thing";

  # the accessor method is required
  requires $accessor;

  if ($p->is eq "rw") {
    requires $add_this_thing;
  } else {
    method $add_this_thing => sub {
      my ($self) = @_;
      my $owner = $self->owner;
      require Carp;
      Carp::croak("Cannot modify read-only collection '$self' " .
                    "belonging to $owner\n");
    };
  }

  # build collection constructor
  method $constructor => sub {
    my ($owner, $opts) = @_;
    $p->factory->new({
      # options => $opts,
      owner => $owner,
    });
  };
};

1;
