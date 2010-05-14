package Prism::Entity::Bool;
use Moose;

use Sub::Exporter::Util;
use Sub::Exporter -setup => {
  exports => {
    true  => Sub::Exporter::Util::curry_class,
    false => Sub::Exporter::Util::curry_class,
  },
};

has is_true => (is => 'ro', isa => 'Bool', required => 1);

my $TRUE  = __PACKAGE__->new({ is_true => 1 });
my $FALSE = __PACKAGE__->new({ is_true => 0 });
sub true  { $TRUE  }
sub false { $FALSE }

sub TO_JSON { $_[0]->is_true ? \1 : \0 }

use overload
  bool => 'is_true',
  '""' => sub { $_[0]->is_true ? 'TRUE' : 'FALSE' },
  '==' => sub { not($_[0] xor $_[1]) };

1;
