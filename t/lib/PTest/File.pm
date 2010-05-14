package PTest::File;
use Moose;

use Prism::Entity::Bool qw(true false);

has filename => (
  is  => 'ro',
  isa => 'Str',
  required => 1,
);

sub data_mgr {
  require PTest::File::DataManager;
  PTest::File::DataManager->for_file($_[0]);
}

sub PRISM_PACK {
  my ($self) = @_;
  return {
    filename => $self->filename,
    exists   => (-e $self->filename ? true : false),
  }
}

1;
