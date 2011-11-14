package Stick::Role::Collection::CanFilter;
{
  $Stick::Role::Collection::CanFilter::VERSION = '0.308';
}
use Moose::Role;

with ('Stick::Role::Collection::HasFilters');

sub filter {
  my ($self, @filters) = @_;

  $self->meta->new_object(
    owner => $self,
    item_array => "items",
    filters => [ @filters ],
  );
}

1;

__END__
=pod

=head1 NAME

Stick::Role::Collection::CanFilter

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

