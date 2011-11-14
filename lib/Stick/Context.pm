package Stick::Context;
{
  $Stick::Context::VERSION = '0.308';
}
use Moose;

# ???
has agent   => (is => 'ro', isa => 'Stick::Agent',   required => 1);
has channel => (is => 'ro', isa => 'Stick::Channel', required => 1);
has token   => (is => 'ro', isa => 'Stick::Token',   required => 1);

1;

__END__
=pod

=head1 NAME

Stick::Context

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

