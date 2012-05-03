package Stick::Types;
# ABSTRACT: type constraints for Stick

use MooseX::Types -declare => [ qw(
  StickBool
  OptionalStickBool
  Factory
  PositiveInt
) ];

use MooseX::Types::Moose qw(Bool Int Object Str);
use Moose::Util::TypeConstraints qw(maybe_type);
use Stick::Entity::Bool;

subtype StickBool,
  as Object,
  where { $_->isa('Stick::Entity::Bool') };

coerce StickBool,
  from Bool,
  via { my $method = $_ ? 'true' : 'false'; Stick::Entity::Bool->$method };

# We need these because plain maybe_type(StickBool) does not have any coercions
subtype OptionalStickBool, as maybe_type(StickBool);

coerce OptionalStickBool,
  from Bool,
  via { my $method = $_ ? 'true' : 'false'; Stick::Entity::Bool->$method };

subtype Factory, as Str | Object;

subtype PositiveInt, as Int, where { $_ > 0 };

1;
