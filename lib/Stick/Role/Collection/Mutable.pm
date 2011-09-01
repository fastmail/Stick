package Stick::Role::Collection::Mutable;
{
  $Stick::Role::Collection::Mutable::VERSION = '0.304';
}
use Moose::Role;

require Stick::Publisher;
use Stick::Publisher::Publish;

requires 'add';

sub resource_post {
  my ($self, @args) = @_;
  $self->add(@args);
};

1;

__END__
=pod

=head1 NAME

Stick::Role::Collection::Mutable

=head1 VERSION

version 0.304

=head1 AUTHOR

Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

