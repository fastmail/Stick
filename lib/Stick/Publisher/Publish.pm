package Stick::Publisher::Publish;
{
  $Stick::Publisher::Publish::VERSION = '0.304';
}
# ABSTRACT: "publish" keyword to declare published methods
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

__END__
=pod

=head1 NAME

Stick::Publisher::Publish - "publish" keyword to declare published methods

=head1 VERSION

version 0.304

=head1 AUTHOR

Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

