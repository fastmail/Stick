package Stick::Publisher::Publish;
use Moose ();
use Moose::Exporter;

use Stick::Error;

Moose::Exporter->setup_import_methods(
  with_meta     => [ qw(publish) ],
);

sub publish {
  my ($caller, $name, $extra, $code) = @_;

  # This appalling hocus-pocus is required to get 'publish' to work
  # inside of parameterized roles; otherwise the package we install
  # into is the parameterizable role, not the generated parameterized
  # role. MJD 2011-03-21
  require MooseX::Role::Parameterized;
  $caller = MooseX::Role::Parameterized->current_metaclass || $caller;

  my $package = $caller->name;

  my $sig = {};
  my $arg = {};

  for my $orig_key (keys %$extra) {
    my $key = $orig_key;

    my $is_dash = $key =~ s/^-//;
    my $target = $is_dash ? $arg : $sig;

    $target->{ $key } = $extra->{ $orig_key };
  }

  require Stick::Publisher::PublishedMethod;
  my $method = Stick::Publisher::PublishedMethod->wrap(
    %$arg,

    body => $code,
    name => $name,
    signature    => $sig,
    package_name => $package,
  );

  $caller->add_method($name => $method);
}

1;
