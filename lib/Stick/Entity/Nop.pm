package Stick::Entity::Nop;
{
  $Stick::Entity::Nop::VERSION = '0.304';
}
use Moose;

has reason => (
  is  => 'ro',
  isa => 'Str',
  default => 'no action required',
);

sub STICK_PACK {
  return { type => 'stick.nop' };
}

1;

__END__
=pod

=head1 NAME

Stick::Entity::Nop

=head1 VERSION

version 0.304

=head1 AUTHOR

Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

