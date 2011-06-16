package PTest::Role::P11dPublishedMethod;
use MooseX::Role::Parameterized;

parameter 'slogan';
use Stick::Publisher::Publish;

role {
  my ($p, %args) = @_;
  require Stick::Publisher;
  Stick::Publisher->import({ into => $args{operating_on}->name });
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
