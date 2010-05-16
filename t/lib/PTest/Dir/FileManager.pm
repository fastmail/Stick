package PTest::Dir::FileManager;
use Moose;

use Moose::Util::TypeConstraints;

with 'Role::Subsystem' => {
  what      => 'dir',
  what_id   => 'dirname',
  ident     => __PACKAGE__,
  id_method => 'dirname',
  type      => class_type('PTest::Dir'),
  getter    => sub {
    require PTest::Dir;
    PTest::Dir->new({ dirname => $_[0] });
  },
};

sub contents {
  my ($self) = @_;

  my $dirname = $self->dirname;
  my @entities;

  for my $name (glob("$dirname/*")) {
    push @entities, -f $name ? PTest::File->new({ filename => $name })
                  : -d $name ? PTest::Dir->new({  dirname  => $name })
                  :            ();
  }

  return \@entities;
}

sub tree {
  my ($self) = @_;

  my $dirname = $self->dirname;
  my @entities;

  for my $name (glob("$dirname/*")) {
    push @entities
      , -f $name ? PTest::File->new({ filename => $name })
      : -d $name ? PTest::Dir->new({  dirname  => $name })->file_mgr->tree
      :            ();
  }

  return \@entities;
}

1;
