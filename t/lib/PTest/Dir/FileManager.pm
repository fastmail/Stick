package PTest::Dir::FileManager;

use Stick::Util -all;
use Moose;
use Moose::Util::TypeConstraints;
use Stick::Publisher 0.20110216;
use namespace::autoclean;

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

publish contents => {} => sub {
  my ($self) = @_;

  my $dirname = $self->dirname;
  my @entities;

  for my $name (glob("$dirname/*")) {
    push @entities, -f $name ? PTest::File->new({ filename => $name })
                  : -d $name ? PTest::Dir->new({  dirname  => $name })
                  :            ();
  }

  return \@entities;
};

publish tree => {} => sub {
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
};

publish contains => { file => obj('PTest::File') } => sub {
  my ($self, $ctx, $arg) = @_;

  my @files = grep { $_->isa('PTest::File') } @{ $self->contents };

  my $wanted_name = $arg->{file}->filename;
  my $contains = grep { $_->filename eq $wanted_name } @files;

  return $contains ? true : false;
};

no Moose;
1;
