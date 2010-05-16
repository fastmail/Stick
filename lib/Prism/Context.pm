package Prism::Context;
use Moose;

# ???
has agent   => (is => 'ro', isa => 'Prism::Agent',   required => 1);
has channel => (is => 'ro', isa => 'Prism::Channel', required => 1);
has token   => (is => 'ro', isa => 'Prism::Token',   required => 1);

1;
