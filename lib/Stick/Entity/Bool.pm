package Stick::Entity::Bool;
BEGIN {
  $Stick::Entity::Bool::VERSION = '0.300';
}
use Moose;

has is_true => (is => 'ro', isa => 'Bool', required => 1);

my $TRUE  = __PACKAGE__->new({ is_true => 1 });
my $FALSE = __PACKAGE__->new({ is_true => 0 });
sub true  { $TRUE  }
sub false { $FALSE }

sub TO_JSON { $_[0]->is_true ? \1 : \0 }

sub STICK_PACK { $_[0] }

use overload
  bool => sub { $_[0]->is_true },
  '""' => sub { $_[0]->is_true ? 'TRUE' : 'FALSE' },
  '==' => sub { not($_[0] xor $_[1]) }; # Crazy?  -- rjbs, 2010-05-16

1;

__END__
=pod

=head1 NAME

Stick::Entity::Bool

=head1 VERSION

version 0.300

=head1 AUTHOR

Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

