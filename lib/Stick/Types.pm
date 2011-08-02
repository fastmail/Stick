package Stick::Types;
# ABSTRACT: type constraints for Stick

use MooseX::Types -declare => [ qw(
  StickBool
  Factory
  PositiveInt
) ];

use MooseX::Types::Moose qw(Bool Int Object Str);

use Stick::Entity::Bool;

subtype StickBool,
  as Object,
  where { $_->isa('Stick::Entity::Bool') };

coerce StickBool,
  from Bool,
  via { my $method = $_ ? 'true' : 'false'; Stick::Entity::Bool->$method };

subtype Factory, as Str | Object;

subtype PositiveInt, as Int, where { $_ > 0 };

1;
