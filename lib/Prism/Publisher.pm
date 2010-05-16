package Prism::Publisher;
use Moose ();
use Moose::Exporter;

Moose::Exporter->setup_import_methods(
  with_caller => [ qw(publish) ],
  also        => 'Moose',
);

sub init_meta {
  my ($class, %args) = @_;

  my $for = $args{for_class};

  Moose->init_meta(for_class => $for);

  # Moose::Util::MetaRole::apply_metaclass_roles(
  #   for_class                => $for,
  #   metaclass_roles          => [ 'Prism::Meta::Trait::Class::Publisher' ],
  # );
}

{
  package Prism::Publisher::PublishedMethod;
  use Moose;
  extends 'Moose::Meta::Method';

  has signature => (
    is  => 'ro',
    isa => 'HashRef',
    required => 1,
  );

  sub _sig_wrapper {
    my ($self, $arg) = @_;

    my $sig  = $arg->{signature};
    my $body = $arg->{body};

    return sub {
      my ($self, $orig_input, $ctx) = @_;
      # confess 'no context provided' unless $ctx->isa('Prism::Context');

      my $new_input = {};
      for my $key (keys %$sig) {
        next unless exists $orig_input->{ $key };
        my $type = $sig->{ $key };

        if ($type->check( $orig_input->{ $key } )) {
          $new_input->{ $key } = $orig_input->{ $key };
        } else {
          $new_input->{ $key } = $type->coerce($orig_input->{ $key });
        }
      }

      $self->$body($new_input, $ctx);
    }
  }

  around wrap => sub {
    my ($orig, $class, %arg) = @_;

    $arg{body} = $class->_sig_wrapper(\%arg);
    return $class->$orig(%arg);
  };

  no Moose;
}

sub publish {
  my ($caller, $name, $sig, $code) = @_;
  my $class  = Moose::Meta::Class->initialize($caller);

  my $method = Prism::Publisher::PublishedMethod->wrap(
    body => $code,
    name => $name,
    signature    => $sig,
    package_name => $caller,
  );

  $class->add_method($name => $method);
}

1;
