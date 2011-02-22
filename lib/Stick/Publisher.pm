package Stick::Publisher;
use Moose ();
use Moose::Exporter;

use Stick::Error;
our $VERSION = 0.20110216;

Moose::Exporter->setup_import_methods(
  with_caller     => [ qw(publish) ],
  class_metaroles => {
    class => [ qw(Stick::Publisher::Role::CanQueryPublished) ],
  },
);

{
  package Stick::Publisher::Role::CanQueryPublished;
  use Moose::Role;

  sub get_all_published_methods {
    my ($meta) = @_;
    return grep { $_->can('is_published') && $_->is_published }
           $meta->get_all_methods;
  }

  sub get_all_published_method_names {
    my ($meta) = @_;
    return map { $_->name } $meta->get_all_published_methods;
  }

  sub methods_published_under_path {
    my ($meta, $path) = @_;

    return grep { $_->path eq $path } $meta->get_all_published_methods;
  }
}

{
  package Stick::Publisher::PublishedMethod;
  use Moose;
  extends 'Moose::Meta::Method';

  use MooseX::StrictConstructor;

  sub is_published { 1 }

  has signature => (
    is  => 'ro',
    isa => 'HashRef',
    required => 1,
  );

  has method => (
    is  => 'ro',
    isa => 'Str', # HTTP: get, post, put, delete; type this -- rjbs, 2011-02-22
    required => 1,
    default  => 'get', # not really thrilled by a default -- rjbs, 2011-02-22
  );

  has path => (
    is  => 'ro',
    isa => 'Str', # consider typing this more strongly, too -- rjbs, 2011-02-22
    lazy    => 1,
    default => sub { $_[0]->name },
  );

  sub _sig_wrapper {
    my ($self, $arg) = @_;

    my $sig  = $arg->{signature};
    my $body = $arg->{body};

    return sub {
      my ($self, $ctx, $orig_input) = @_;
      # confess 'no context provided' unless $ctx->isa('Stick::Context');

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
        Stick::Error->throw({
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
  my ($caller, $name, $extra, $code) = @_;
  my $class  = Moose::Meta::Class->initialize($caller);

  my $sig = {};
  my $arg = {};

  for my $orig_key (keys %$extra) {
    my $key = $orig_key;

    my $is_dash = $key =~ s/^-//;
    my $target = $is_dash ? $arg : $sig;

    $target->{ $key } = $extra->{ $orig_key };
  }

  my $method = Stick::Publisher::PublishedMethod->wrap(
    %$arg,

    body => $code,
    name => $name,
    signature    => $sig,
    package_name => $caller,
  );

  $class->add_method($name => $method);
}

1;
