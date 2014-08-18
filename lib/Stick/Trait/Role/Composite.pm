package Stick::Trait::Role::Composite;

use Moose::Role;

use Moose::Util::MetaRole;
use Moose::Util qw(does_role);

use namespace::autoclean;

with 'Stick::Trait::Role';

around apply_params => sub {
    my $orig = shift;
    my $self = shift;

    $self->$orig(@_);

    $self = Moose::Util::MetaRole::apply_metaroles(
        for            => $self,
        role_metaroles => {
            application_to_class => [ 'Stick::Trait::Application::ToClass' ],
            application_to_role  => [ 'Stick::Trait::Application::ToRole'  ],
        },
    );

    return $self;
};

1;
