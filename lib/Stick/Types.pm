package Stick::Types;
# ABSTRACT: type constraints for Stick

use MooseX::Types -declare => [ qw(
  StickBool
) ];

use MooseX::Types::Moose qw(Bool Object);

use Stick::Entity::Bool;

subtype StickBool,
  as Object,
  where { $_->isa('Stick::Entity::Bool') };

coerce StickBool,
  from Bool,
  via { my $method = $_ ? 'true' : 'false'; Stick::Entity::Bool->$method };

1;
