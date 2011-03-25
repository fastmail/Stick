package PTest::File::DataManager;

use MooseX::Types::Moose qw(Int);
use Moose::Util::TypeConstraints;
use Moose;

use Stick::Publisher 0.20110324;
use Stick::Publisher::Publish 0.20110324;
use namespace::autoclean;

with 'Role::Subsystem' => {
  what      => 'file',
  what_id   => 'filename',
  ident     => __PACKAGE__,
  id_method => 'filename',
  type      => class_type('PTest::File'),
  getter    => sub {
    require PTest::File;
    PTest::File->new({ filename => $_[0] });
  },
};

publish size => { } => sub { -s $_[0]->filename };

publish size_plus => { plus => Int } => sub {
  my ($self, $arg) = @_;
  my $plus = $arg->{plus};

  $plus + -s $self->filename;
};

1;
