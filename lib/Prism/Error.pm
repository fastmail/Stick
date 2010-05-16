package Prism::Error;
use Moose;
extends 'Throwable::Error';

has user_visible => (is => 'ro', isa => 'Bool', default => 0);

has ident   => (is => 'ro', isa => 'Str', required => 1);
has message => (is => 'ro', isa => 'Str', required => 1);

has data => (is => 'ro', isa => 'HashRef', default => sub { {} });

sub type { 'error' };

sub PRISM_PACK {
  my ($self) = @_;

  my $error;

  if (not $self->user_visible) {
    $error = {
      ident   => 'internal error',
      message => 'an internal error occurred',
      data    => {},
      type    => 'error.internal',
    };
  } else {
    $error = {
      ident   => $self->ident,
      message => $self->message,
      data    => $self->data,
      type    => $self->type,
    };
  }
}

1;
