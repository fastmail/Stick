package Stick::Role::Collection::Mutable;
use Moose::Util::TypeConstraints qw(role_type);
use MooseX::Role::Parameterized;
use MooseX::Types::Moose qw(Any ArrayRef HashRef Str);

# name of the owner method that adds a new item of this type to the owner
parameter add_this_item => (
  is => 'ro',
  isa => Str,
  required => 1,
);

# method that handles POST requests to this collection
parameter post_action => (
  isa => Str,
  is => 'ro',
  default => 'add',
);

parameter post_action => (
  isa => Str,
  is => 'ro',
  default => 'add',
);

require Stick::Publisher;
use Stick::Publisher::Publish;

role {
  my ($p, %args) = @_;

  Stick::Publisher->import({ into => $args{operating_on}->name });
  sub publish;

  my $add_this_item   = $p->add_this_item;
  my $post_action     = $p->post_action;

  publish add => { attributes => HashRef } => sub {
    my ($self, $attrs) = @_;
    $self->owner->$add_this_item($arg->{attributes});
  };

  # XXX Fix
  method resource_post => sub {
    my ($self, @args) = @_;
    $self->$post_action(@args);
   };

};

1;
