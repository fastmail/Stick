package Stick::Role::PublicResource;
{
  $Stick::Role::PublicResource::VERSION = '0.303';
}
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

Stick::Role::PublicResource

=head1 VERSION

version 0.303

=head1 AUTHOR

Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

