package PTest::File;
use Moose;
use Moose::Util::TypeConstraints;

use Stick::Util -all;

coerce obj( __PACKAGE__ ),
  from 'Str',
  via { __PACKAGE__->new({ filename => $_ }) };

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
