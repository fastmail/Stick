package Stick::Role::Routable;
# ABSTRACT: An object that can be routed through

use Moose::Role;
use HTTP::Throwable::Factory;

use namespace::autoclean;

requires '_subroute';

sub route {
  my ($self, $orig_path) = @_;

  HTTP::Throwable::Factory->throw('NotFound')
    unless my (@remaining_path) = @$orig_path;

  my $next_step = $self;

  PATH_PART: while (1) {
    if (! @remaining_path) {
      # we're at the end!  make sure it's a PublicResource and return it

      # This should probably be a 404, but we want to know if people are
      # hitting it a lot, because ... why are they building some bogus URL like
      # this? -- rjbs, 2011-02-22
      Stick::Error->throw("non-PublicResource endpoint reached")
        unless $next_step->does('Stick::Role::PublicResource');

      return $next_step;
    };

    my $part_count = @remaining_path;

    # non-productive routing -- if set, we don't mind if the remaining path
    # stays the same length -- rjbs, 2011-07-18
    my $npr_allowed = 0;
    $next_step = $next_step->_subroute( \@remaining_path, \$npr_allowed );

    HTTP::Throwable::Factory->throw('NotFound') unless $next_step;

    Stick::Error->throw("non-productive routing not allowed")
      unless @remaining_path < $part_count || $npr_allowed;
  }
}

1;
