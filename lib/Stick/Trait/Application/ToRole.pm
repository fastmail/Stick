package Stick::Trait::Application::ToRole;

use strict;
use warnings;

use namespace::autoclean;
use Moose::Role;

around apply => sub {
    my $orig  = shift;
    my $self  = shift;
    my $role1 = shift;
    my $role2 = shift;

    $role2 = Moose::Util::MetaRole::apply_metaroles(
      for            => $role2,
      role_metaroles => {
        application_to_class => [ 'Stick::Trait::Application::ToClass' ],
        application_to_role => [ 'Stick::Trait::Application::ToRole' ],
      },
    );

    $self->$orig( $role1, $role2 );
};

1;
