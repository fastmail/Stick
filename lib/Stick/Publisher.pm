package Stick::Publisher;
{
  $Stick::Publisher::VERSION = '0.302';
}
use Moose ();
use Moose::Exporter;

use Stick::Error;

require Stick::Trait::Class::CanQueryPublished;

Moose::Exporter->setup_import_methods(
  class_metaroles => {
    class     => [ qw(Stick::Trait::Class::CanQueryPublished) ],
    attribute => [ qw(Stick::Trait::Attribute::Publishable) ],
  },
  role_metaroles => {
    role                 => [ 'Stick::Trait::Role'],
    applied_attribute    => [ qw(Stick::Trait::Attribute::Publishable) ],
    application_to_class => [ 'Stick::Trait::Application::ToClass' ],
    application_to_role  => [ 'Stick::Trait::Application::ToRole'  ],
  },
);

1;

__END__
=pod

=head1 NAME

Stick::Publisher

=head1 VERSION

version 0.302

=head1 AUTHOR

Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

