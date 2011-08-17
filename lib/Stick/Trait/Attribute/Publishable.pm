package Stick::Trait::Attribute::Publishable;
{
  $Stick::Trait::Attribute::Publishable::VERSION = '0.302';
}
use Moose::Role;

use Moose::Util::TypeConstraints qw(enum);

use namespace::autoclean;

has publish_as => (
  is  => 'ro',
  isa  => 'Str',
  lazy => 1,
  default => sub { $_[0]->name },
);

has publish_is => (
  is  => 'ro',

  # XXX: Eventually we can have "rw" for PUT setters -- rjbs, 2011-02-25
  isa => enum([ qw(ro ro) ]),
);

1;

__END__
=pod

=head1 NAME

Stick::Trait::Attribute::Publishable

=head1 VERSION

version 0.302

=head1 AUTHOR

Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

