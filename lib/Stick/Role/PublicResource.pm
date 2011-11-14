package Stick::Role::PublicResource;
{
  $Stick::Role::PublicResource::VERSION = '0.308';
}
# ABSTRACT: An object to which HTTP requests can be routed
use Moose::Role;

use Stick::Error;

use namespace::autoclean;

# might provide:
#   resource_get
#   resource_post
#   resource_put
#   resouce_delete

sub resource_request {
  my ($self, $method, $arg) = @_;

  my $method_name = "resource_$method";

  unless ($self->can($method_name)) {
    Stick::Error->throw("bad method");
    # return [
    #   405,
    #   [ 'Content-type' => 'application/json' ],
    #   [ q<{ "error": "method not supported" }> ],
    # ];
  }

  return scalar $self->$method_name($arg);
}

1;

__END__
=pod

=head1 NAME

Stick::Role::PublicResource - An object to which HTTP requests can be routed

=head1 VERSION

version 0.308

=head1 AUTHORS

=over 4

=item *

Ricardo Signes <rjbs@cpan.org>

=item *

Mark Jason Dominus <mjd@cpan.org>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Ricardo Signes, Mark Jason Dominus.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

