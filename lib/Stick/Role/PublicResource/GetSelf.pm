package Stick::Role::PublicResource::GetSelf;
{
  $Stick::Role::PublicResource::GetSelf::VERSION = '0.308';
}
# ABSTRACT: An object for which an HTTP GET method returns the object itself
use Moose::Role;

use Stick::Error;

with(
  'Stick::Role::PublicResource',
);

use namespace::autoclean;

sub resource_get { return $_[0] }

1;

__END__
=pod

=head1 NAME

Stick::Role::PublicResource::GetSelf - An object for which an HTTP GET method returns the object itself

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

