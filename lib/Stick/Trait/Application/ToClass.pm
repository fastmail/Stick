package Stick::Trait::Application::ToClass;
BEGIN {
  $Stick::Trait::Application::ToClass::VERSION = '0.300';
}

use strict;
use warnings;

use namespace::autoclean;
use Moose::Role;

around apply => sub {
    my $orig = shift;
    my $self  = shift;
    my $role  = shift;
    my $class = shift;

    $class = Moose::Util::MetaRole::apply_metaroles(
      for             => $class,
      class_metaroles => {
        class     => [ 'Stick::Trait::Class::CanQueryPublished' ],
        attribute => [ qw(Stick::Trait::Attribute::Publishable) ],
      },
    );

    $self->$orig( $role, $class );
};

1;

__END__
=pod

=head1 NAME

Stick::Trait::Application::ToClass

=head1 VERSION

version 0.300

=head1 AUTHOR

Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

