package Stick::Trait::Role;
BEGIN {
  $Stick::Trait::Role::VERSION = '0.300';
}
use Moose::Role;

use Scalar::Util qw( blessed );

use namespace::autoclean;

sub composition_class_roles {
    return 'Stick::Trait::Role::Composite';
}

1;

__END__
=pod

=head1 NAME

Stick::Trait::Role

=head1 VERSION

version 0.300

=head1 AUTHOR

Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

