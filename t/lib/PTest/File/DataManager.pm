package PTest::File::DataManager;
use Stick::Publisher;

use MooseX::Types::Moose qw(Int);
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

publish size => { } => sub { -s $_[0]->filename };

publish size_plus => { plus => Int } => sub {
  my ($self, $ctx, $arg) = @_;
  my $plus = $arg->{plus};

  $plus + -s $self->filename;
};

1;
