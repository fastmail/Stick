package PTest::Dir;
use Moose;

use Prism::Entity::Bool qw(true false);

has dirname => (
  is  => 'ro',
  isa => 'Str',
  required => 1,
);

sub file_mgr {
  require PTest::Dir::FileManager;
  PTest::Dir::FileManager->for_dir($_[0]);
}

sub PRISM_PACK {
  my ($self) = @_;
  return {
    dirname => $self->dirname,
    exists  => (-e $self->dirname ? true : false),
  }
}

1;
