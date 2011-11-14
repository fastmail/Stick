package Stick::WrappedMethod;
{
  $Stick::WrappedMethod::VERSION = '0.308';
}
# ABSTRACT: a handler for an HTTP request
use Moose;

with(
  'Stick::Role::PublicResource',
);

use Moose::Util::TypeConstraints;
use MooseX::Types::Moose qw(CodeRef);
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
  isa => class_type('Moose::Meta::Method') | CodeRef,
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

Stick::WrappedMethod - a handler for an HTTP request

=head1 VERSION

version 0.308

=head1 AUTHORS

=over 4

=item *

Ricardo Signes <rjbs@cpan.org>

=item *

Mark Jason Dominus <mjd@cpan.org>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Ricardo Signes, Mark Jason Dominus.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

