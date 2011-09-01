package Stick::Context;
{
  $Stick::Context::VERSION = '0.304';
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

version 0.304

=head1 AUTHOR

Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

