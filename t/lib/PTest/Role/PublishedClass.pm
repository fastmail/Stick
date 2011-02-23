package PTest::Role::PublishedClass;
use Moose::Role;
use Stick::Publisher;

publish class => {} => sub {
  my ($self) = @_;

  return $self->meta->name;
};

1;
