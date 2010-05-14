package PTest::File::DataManager;
use Moose;

use Moose::Util::TypeConstraints;

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

sub size { -s $_[0]->filename }

1;
