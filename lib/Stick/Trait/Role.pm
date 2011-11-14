package Stick::Trait::Role;
{
  $Stick::Trait::Role::VERSION = '0.308';
}
use Moose::Role;

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

