package Stick::Trait::Role;
use Moose::Role;

use Scalar::Util qw( blessed );

use namespace::autoclean;

sub composition_class_roles {
    return 'Stick::Trait::Role::Composite';
}

1;
