package Stick::Publisher;
use Moose ();
use Moose::Exporter;

use Stick::Error;

require Stick::Trait::Class::CanQueryPublished;

Moose::Exporter->setup_import_methods(
  class_metaroles => {
    class     => [ qw(Stick::Trait::Class::CanQueryPublished) ],
    attribute => [ qw(Stick::Trait::Attribute::Publishable) ],
  },
  role_metaroles => {
    role                 => [ 'Stick::Trait::Role'],
    applied_attribute    => [ qw(Stick::Trait::Attribute::Publishable) ],
    application_to_class => [ 'Stick::Trait::Application::ToClass' ],
    application_to_role  => [ 'Stick::Trait::Application::ToRole'  ],
  },
);

1;
