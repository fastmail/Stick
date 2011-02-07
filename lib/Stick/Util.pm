package Stick::Util;
use strict;
use warnings;

use Moose::Util::TypeConstraints;
use Params::Util qw(_ARRAY0 _HASH0);
use Stick::Entity::Bool;
use Stick::Entity::Nop;
use Scalar::Util ();
use Try::Tiny;

use Sub::Exporter::Util ();
use Sub::Exporter -setup => {
  exports => [
    ppack  => Sub::Exporter::Util::curry_method,
    true   => Sub::Exporter::Util::curry_method,
    false  => Sub::Exporter::Util::curry_method,
    nop    => Sub::Exporter::Util::curry_method,
    is_nop => Sub::Exporter::Util::curry_method('value_is_nop'),
    obj    => Sub::Exporter::Util::curry_method,
  ],
};

sub _ppack_recursive {
  my ($value) = @_;

  return $value unless ref($value);

  if (Scalar::Util::blessed($value)) {
    return $value->STICK_PACK if $value->can('STICK_PACK');
    die "no route to ppack $value";
  }

  return [ map {; _ppack_recursive($_) } @$value ] if _ARRAY0($value);

  return { map {; $_ => _ppack_recursive($_) } keys %$value } if _HASH0($value);

  die "no route to ppack $value";
}

sub ppack {
  my ($self, $value) = @_;

  return { value => _ppack_recursive($value) };
}

sub true  { Stick::Entity::Bool->true  }
sub false { Stick::Entity::Bool->false }

sub nop   {
  my ($self, $reason) = @_;
  Stick::Entity::Nop->new(defined $reason ? (reason => $reason) : ());
}

sub value_is_nop {
  return(Scalar::Util::blessed($_[1]) and $_[1]->isa('Stick::Entity::Nop'));
}

my %OBJ_TYPE;
sub obj {
  my ($self, $class) = @_;

  $OBJ_TYPE{ $class } ||= class_type($class);
}

1;
