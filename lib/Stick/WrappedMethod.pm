package Stick::WrappedMethod;
BEGIN {
  $Stick::WrappedMethod::VERSION = '0.300';
}
use Moose;

with(
  'Stick::Role::PublicResource',
);

use namespace::autoclean;

has invocant => (
  is  => 'ro',
  isa => 'Defined',
  required => 1,
);

my @methods = qw(get put post delete);

require Moose::Meta::Method;

has [ map {; "$_\_method" } @methods ] => (
  is  => 'ro',
  isa => 'Moose::Meta::Method',
);

for my $method (@methods) {
  Sub::Install::install_sub({
    as   => "resource_$method",
    code => sub {
      my ($self, $arg) = @_;
      my $proxy_name   = "$method\_method";
      Moonpig::X->throw("bad http method")
        unless my $proxy_method = $self->$proxy_name;
      return $proxy_method->($self->invocant, $arg);
    },
  });
}

1;

__END__
=pod

=head1 NAME

Stick::WrappedMethod

=head1 VERSION

version 0.300

=head1 AUTHOR

Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

