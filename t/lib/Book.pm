package t::lib::Book;
use Moose::Role;

my $ID = 0;
has guid => (isa => 'Num',
             is => 'ro',
             init_arg => undef,
             default => sub { ++$ID },
            );

sub id { $_[0]->guid }

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

sub STICK_PACK {
  my ($self) = @_;
  return {
    author => $self->author,
    title  => $self->title,
    length => $self->length,
  };
}

1;
