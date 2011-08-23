package Stick::Publisher::PublishedMethod;
{
  $Stick::Publisher::PublishedMethod::VERSION = '0.303';
}
use Moose 1.25;
extends 'Moose::Meta::Method';

use MooseX::StrictConstructor;

sub is_published { 1 }

has signature => (
  is  => 'ro',
  isa => 'HashRef',
  required => 1,
 );

has http_method => (
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
    my ($self, $orig_input) = @_;

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
      return $self->$body(\%input);
    }
  }
}

around wrap => sub {
  my ($orig, $class, %arg) = @_;

  $arg{body} = $class->_sig_wrapper(\%arg);
  return $class->$orig(%arg);
};

no Moose;
1;

__END__
=pod

=head1 NAME

Stick::Publisher::PublishedMethod

=head1 VERSION

version 0.303

=head1 AUTHOR

Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

