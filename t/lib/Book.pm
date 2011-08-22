package t::lib::Book;
use Moose::Role;

my $ID = 0;
has id => (isa => 'Num',
           is => 'ro',
           init_arg => undef,
           default => sub { ++$ID },
          );

has author => (isa => 'Str',
               is => 'ro',
              );

has title => (isa => 'Str',
              is => 'ro',
             );

has length => (isa => 'Num',
               is => 'ro',
              );

sub as_str {
  my ($self) = @_;
  sprintf qq{Book #%s "%s", by %s (%s pages)},
    $self->id, $self->title, $self->author, $self->length;
}

1;
