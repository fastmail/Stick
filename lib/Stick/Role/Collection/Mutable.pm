package Stick::Role::Collection::Mutable;
use MooseX::Role::Parameterized;

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

role {
  my $add_this_item   = $p->add_this_item;
  my $post_action     = $p->post_action;

  my ($p, %args) = @_;

  Stick::Publisher->import({ into => $args{operating_on}->name });
  sub publish;

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
