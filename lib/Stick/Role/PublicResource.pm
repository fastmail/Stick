package Stick::Role::PublicResource;
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
