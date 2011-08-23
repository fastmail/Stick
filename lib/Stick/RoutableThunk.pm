package Stick::RoutableThunk;
{
  $Stick::RoutableThunk::VERSION = '0.303';
}
use Moose;

use namespace::autoclean;

with('MooseX::OneArgNew' => {
  type => 'CodeRef',
  init_arg => 'code',
});

has code => (
  is  => 'ro',
  isa => 'CodeRef',
  required => 1,
);

sub _subroute {
  my ($self, $path, $npr_ok) = @_;
  $$npr_ok = 1;
  return $self->code->();
}

1;

__END__
=pod

=head1 NAME

Stick::RoutableThunk

=head1 VERSION

version 0.303

=head1 AUTHOR

Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

