package Stick::Role::Collection::HasFilters;
{
  $Stick::Role::Collection::HasFilters::VERSION = '0.304';
}
use Moose::Role;
use MooseX::Types::Moose qw(ArrayRef CodeRef);

# filters return true or false
# an item is in the collection only if *all* filters return true
# replace this with a boolean tree structure later on - MJD 20110816
has filters => (
  is => 'ro',
  isa => ArrayRef[CodeRef],
  default => sub { [] },
);

around items => sub {
  my ($orig, $self, @args) = @_;
  my $items = $self->$orig(@args);
  return $items unless @{$self->filters};
  return [ grep $self->_item_in_collection($_), @$items ];
};

sub _item_in_collection {
  my ($self, $item) = @_;
  my $filters = $self->filters;
  local $_ = $item;
  for my $f (@$filters) { $f->($_) || return }
  return 1;
}

1;


__END__
=pod

=head1 NAME

Stick::Role::Collection::HasFilters

=head1 VERSION

version 0.304

=head1 AUTHOR

Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

