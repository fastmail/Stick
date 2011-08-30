package Stick::Role::Collection::Mutable;
use Moose::Role;

require Stick::Publisher;
use Stick::Publisher::Publish;

requires 'add';

sub resource_post {
  my ($self, @args) = @_;
  $self->add(@args);
};

1;
