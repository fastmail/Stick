package t::lib::Book;
use Moose::Role;

my $ID = 0;
has id => (isa => 'Num',
           is => 'ro',
           init_arg => undef,
           default => sub { ++$ID },
          );

1;
