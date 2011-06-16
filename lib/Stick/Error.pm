package Stick::Error;
BEGIN {
  $Stick::Error::VERSION = '0.300';
}
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

__END__
=pod

=head1 NAME

Stick::Error

=head1 VERSION

version 0.300

=head1 AUTHOR

Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

