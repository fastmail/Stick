package Stick::Trait::Attribute::Publishable;
{
  $Stick::Trait::Attribute::Publishable::VERSION = '0.308';
}
# ABSTRACT: A trait for an attribute whose accessor is published
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

Stick::Trait::Attribute::Publishable - A trait for an attribute whose accessor is published

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

