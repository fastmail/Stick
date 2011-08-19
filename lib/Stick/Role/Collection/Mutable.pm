package Stick::Role::Collection::Mutable;
use Moose::Util::TypeConstraints qw(role_type);
use MooseX::Role::Parameterized;
use MooseX::Types::Moose qw(Any ArrayRef Str);

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

parameter item_roles => (
  isa => ArrayRef [ Str ],
  is => 'ro',
  required => 1,
);

sub item_type {
  my ($p) = @_;
  my @roles = map role_type($_), @{$p->item_roles};
  if (@roles == 0) { return Any }
  elsif (@roles == 1) { return $roles[0] }
  else {
    require Moose::Meta::TypeConstraint::Union;
    return Moose::Meta::TypeConstraint::Union
      ->new(type_constraints => \@roles);
  }
}

require Stick::Publisher;
use Stick::Publisher::Publish;

role {
  my ($p, %args) = @_;

  Stick::Publisher->import({ into => $args{operating_on}->name });
  sub publish;

  my $add_this_item   = $p->add_this_item;
  my $post_action     = $p->post_action;
  my $item_type       = item_type($p);

  publish add => { new_item => $item_type } => sub {
    my ($self, $arg) = @_;
    $self->owner->$add_this_item($arg->{new_item});
  };

  # XXX Fix
  method resource_post => sub {
    my ($self, @args) = @_;
    $self->$post_action(@args);
   };

};

1;
