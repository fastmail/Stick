package Stick::Trait::Application::ToClass;

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
