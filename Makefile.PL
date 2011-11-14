
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "a web framework",
  "AUTHOR" => "Ricardo Signes <rjbs\@cpan.org>, Mark Jason Dominus <mjd\@cpan.org>",
  "BUILD_REQUIRES" => {
    "Role::Subsystem" => 0,
    "Test::Deep" => 0,
    "Test::Fatal" => 0,
    "Test::More" => "0.96",
    "Test::Routine" => 0,
    "Test::Routine::Util" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Stick",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "Stick",
  "PREREQ_PM" => {
    "Carp" => 0,
    "Data::Dumper" => 0,
    "HTTP::Throwable::Factory" => 0,
    "JSON" => 2,
    "List::Util" => 0,
    "Moose" => "1.25",
    "Moose::Exporter" => 0,
    "Moose::Meta::Method" => 0,
    "Moose::Role" => 0,
    "Moose::Util" => 0,
    "Moose::Util::MetaRole" => 0,
    "Moose::Util::TypeConstraints" => 0,
    "MooseX::ClassCompositor" => 0,
    "MooseX::OneArgNew" => 0,
    "MooseX::Role::Parameterized" => 0,
    "MooseX::StrictConstructor" => 0,
    "MooseX::Types" => 0,
    "MooseX::Types::Moose" => 0,
    "POSIX" => 0,
    "Params::Util" => 0,
    "Scalar::Util" => 0,
    "String::Formatter" => 0,
    "Sub::Exporter" => 0,
    "Sub::Exporter::Util" => 0,
    "Throwable::Error" => 0,
    "Try::Tiny" => 0,
    "namespace::autoclean" => 0,
    "overload" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "VERSION" => "0.308",
  "test" => {
    "TESTS" => "t/*.t t/collections/*.t t/route/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



