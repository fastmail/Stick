package Stick::Context;

use Moose;

# ???
has agent   => (is => 'ro', isa => 'Stick::Agent',   required => 1);
has channel => (is => 'ro', isa => 'Stick::Channel', required => 1);
has token   => (is => 'ro', isa => 'Stick::Token',   required => 1);

1;
