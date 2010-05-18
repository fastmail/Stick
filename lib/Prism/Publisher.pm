package Prism::Publisher;
use Moose ();
use Moose::Exporter;

use Prism::Error;

Moose::Exporter->setup_import_methods(
  with_caller => [ qw(publish) ],
  also        => 'Moose',
);

# sub init_meta { }

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
      my ($self, $ctx, $orig_input) = @_;
      # confess 'no context provided' unless $ctx->isa('Prism::Context');

      my %unknown = map {; $_ => 1 } keys %$orig_input;
      my %error;
      my %input;

      for my $key (keys %$sig) {
        delete $unknown{ $key };
        my $value = $orig_input->{$key};
        my $type  = $sig->{ $key };

        if (! defined $value) {
          if ($type->is_subtype_of('Maybe')) {
            $input{ $key } = undef;
          } else {
            $error{ $key } = 'missing';
          }
          next;
        }

        if ($type->check( $orig_input->{ $key } )) {
          $input{ $key } = $orig_input->{ $key };
        } else {
          my $new_value = eval { $type->coerce($orig_input->{ $key }); };
          if (defined $new_value) {
            $input{ $key } = $new_value;
          } else {
            $error{ $key } = 'invalid';
          }
        }
      }

      $error{$_} = 'unknown' for keys %unknown;

      if (keys %error) {
        Prism::Error->throw({
          ident   => 'invalid method call',
          message => 'invalid arguments to method %{method}s',
          public  => 1,
          data    => {
            method => $arg->{name},
            errors => \%error,
          },
        });
      } else {
        return $self->$body($ctx, \%input);
      }
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
