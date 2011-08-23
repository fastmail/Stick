package Stick::Util;
{
  $Stick::Util::VERSION = '0.303';
}
use strict;
use warnings;

use JSON 2 ();
use Moose::Util qw(apply_all_roles);
use Moose::Util::TypeConstraints;
use MooseX::ClassCompositor;
use Params::Util qw(_ARRAY0 _HASH0);
use Scalar::Util ();
use Stick::Entity::Bool;
use Stick::Entity::Nop;
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
    json_pack => Sub::Exporter::Util::curry_method,
    'class',
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

  return { map {; $_ => _ppack_recursive($value->{$_}) } keys %$value }
    if _HASH0($value);

  die "no route to ppack $value";
}

sub ppack {
  my ($self, $value) = @_;

  _ppack_recursive($value);
}

my $JSON = JSON->new->ascii(1)->convert_blessed(1)->allow_blessed(1);

sub json_pack {
  my ($self, $entity) = @_;

  return $JSON->encode({ value => $self->ppack( $entity ) });
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

my $COMPOSITOR = MooseX::ClassCompositor->new({
  class_basename  => 'Stick::Class',
  class_metaroles => {
    class => [ 'MooseX::StrictConstructor::Trait::Class' ],
  },
});


sub class { $COMPOSITOR->class_for(@_) }

1;

__END__
=pod

=head1 NAME

Stick::Util

=head1 VERSION

version 0.303

=head1 AUTHOR

Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

