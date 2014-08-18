package Stick::Error;
# ABSTRACT: Stick exception object

use Moose;
extends 'Throwable::Error';

with('MooseX::OneArgNew' => {
  type => 'Str',
  init_arg => 'ident',
});

use String::Formatter named_stringf => {
  -as   => '__stringf',
  codes => { s => sub { $_ } },
};

has public => (is => 'ro', isa => 'Bool', default => 0);

has ident  => (is => 'ro', isa => 'Str', required => 1);

has message_fmt => (
  is  => 'ro',
  isa => 'Str',
  lazy => 1,
  default => sub { $_[0]->ident },
  init_arg => 'message',
);

has message => (
  is       => 'ro',
  lazy     => 1,
  init_arg => undef,
  default  => sub { __stringf($_[0]->message_fmt, $_[0]->data) },
);

has data => (is => 'ro', isa => 'HashRef', default => sub { {} });

sub type { 'error' };

sub as_string {
  my ($self, @args) = @_;
  require Data::Dumper;
  my @parts = ($self->message);
  push @parts, "{" . Data::Dumper::Dumper($self->{data}) . "}"
    if $ENV{STICK_FULL_ERROR_DATA};
  push @parts, $self->stack_trace->as_string
    unless $ENV{STICK_SUPPRESS_STACK_TRACE};
  return join "\n\n", @parts;
}

sub STICK_PACK {
  my ($self) = @_;

  if ($self->public) {
    return {
      ident   => $self->ident,
      message => $self->message_fmt,
      data    => $self->data,
      type    => $self->type,
    };
  } else {
    return {
      ident   => 'internal error',
      message => 'an internal error occurred',
      data    => {},
      type    => 'error.internal',
    };
  }
}

1;
