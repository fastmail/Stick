package Prism::Util;
use strict;
use warnings;

use Params::Util qw(_ARRAY0 _HASH0);
use Scalar::Util ();
use Sub::Exporter::Util ();
use Sub::Exporter -setup => {
  exports => [
    ppack => Sub::Exporter::Util::curry_method,
  ],
};

sub _ppack_recursive {
  my ($value) = @_;

  return $value unless ref $value;

  if (Scalar::Util::blessed($value)) {
    return $value->PRISM_PACK if $value->can('PRISM_PACK');
    die "no route to ppack";
  }

  return [ map {; _ppack_recursive($_) } @$value ] if _ARRAY0($value);

  return { map {; $_ => _ppack_recursive($_) } keys %$value } if _HASH0($value);

  die "no route to ppack";
}

sub ppack {
  my ($self, $value) = @_;

  return { value => $value } unless ref $value;
  return _ppack_recursive($value);
}

1;
