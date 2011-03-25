package PTest::Dir;
use Moose;
use Moose::Util::TypeConstraints;
use Stick::Publisher;

use Stick::Util -all;

coerce obj( __PACKAGE__ ),
  from 'Str',
  via { __PACKAGE__->new({ dirname => $_ }) };

has dirname => (
  is  => 'ro',
  isa => 'Str',
  required => 1,
);

sub file_mgr {
  require PTest::Dir::FileManager;
  PTest::Dir::FileManager->for_dir($_[0]);
}

sub STICK_PACK {
  my ($self) = @_;
  return {
    dirname => $self->dirname,
    exists  => (-e $self->dirname ? true : false),
  }
}

1;
