package Stick::Entity::Bool;
use Moose;

has is_true => (is => 'ro', isa => 'Bool', required => 1);

my $TRUE  = __PACKAGE__->new({ is_true => 1 });
my $FALSE = __PACKAGE__->new({ is_true => 0 });
sub true  { $TRUE  }
sub false { $FALSE }

sub TO_JSON { $_[0]->is_true ? \1 : \0 }

sub STICK_PACK { $_[0] }

use overload
  bool => sub { $_[0]->is_true },
  '""' => sub { $_[0]->is_true ? 'TRUE' : 'FALSE' },
  '==' => sub { not($_[0] xor $_[1]) }; # Crazy?  -- rjbs, 2010-05-16

1;
