package PTest::Role::P11dPublishedMethod;
use MooseX::Role::Parameterized;

parameter 'slogan';

role {
  my ($p) = @_;
  require Stick::Publisher;
  Stick::Publisher->import();
  sub publish;
  my $slogan = $p->slogan;

  publish published_method => {} => sub {
    my ($self) = @_;

    return $slogan;
  };

  method unpublished_method => sub {
    my ($self) = @_;

    return "With your mouth";
  };
};

1;
