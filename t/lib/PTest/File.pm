package PTest::File;
use Moose;
use Moose::Util::TypeConstraints;
use Stick::Publisher;

with(
  'PTest::Role::PublishedClass',             # gets us the published
  'Stick::Role::Routable::ClassAndInstance', # for two sets of routes
  'Stick::Role::Routable::AutoInstance',
);

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

sub STICK_PACK {
  my ($self) = @_;
  return {
    filename => $self->filename,
    exists   => (-e $self->filename ? true : false),
  }
}

sub _class_subroute { }

1;
