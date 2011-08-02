package Stick::Util;
use strict;
use warnings;

use JSON 2 ();
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

my $SERIAL = "aa";
sub class {
  my (@args) = @_;
  my @orig_args = @args;

  # $role_hash is a hash mapping nonce-names to role objects
  # $role_names is an array of names of more roles to add
  my (@roles, @role_class_names, @all_names);

  while (@args) {
    my $name = shift @args;
    if (ref $name) {
      my ($role_name, $moniker, $params) = @$name;

      my $full_name = _rewrite_prefix($role_name);
      Class::MOP::load_class($full_name);
      my $role_object = $full_name->meta->generate_role(
        parameters => $params,
      );

      push @roles, $role_object;
      $name = $moniker;
    } else {
      push @role_class_names, $name;
    }

    $name =~ s/::/_/g if @all_names;
    $name =~ s/^=//;

    push @all_names, $name;
  }

  my $name = join q{::}, 'Moonpig::Class', @all_names;

  @role_class_names = _rewrite_prefix(@role_class_names);

  Class::MOP::load_class($_) for @role_class_names;

  if ($name->can('meta')) {
    $name .= "_" . $SERIAL++;
  }
  my $class = Moose::Meta::Class->create( $name => (
    superclasses => [ 'Moose::Object' ],
  ));

  apply_all_roles($class, @role_class_names, map $_->name, @roles);

  $class = Moose::Util::MetaRole::apply_metaroles(
    for => $class->name,
    class_metaroles => {
      class => [ 'MooseX::StrictConstructor::Trait::Class' ],
    },
  );

  $class->make_immutable;

  return $class->name;
}

1;
