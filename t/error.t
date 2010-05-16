use strict;
use warnings;
use Test::More;

use lib 't/lib';

use JSON 2;
use Prism::Util qw(ppack);
use Prism::Error;

my $JSON = JSON->new->ascii(1)->convert_blessed(1)->allow_blessed(1);

sub jdiag { diag($JSON->encode($_[0])) }

{
  my $error = Prism::Error->new({
    ident   => 'event prohibits travel',
    message => 'cannot travel from %{src}s to %{dest}s during %{event}s',
    data    => {
      src    => 'London',
      dest   => 'New York',
      event  => 'volcanic eruption',
    },
  });

  is(
    $error->message,
    'cannot travel from London to New York during volcanic eruption',
    'error message is formatted on demand',
  );

  jdiag( ppack( $error ));
}

{
  my $error = Prism::Error->new({
    public  => 1,
    ident   => 'event prohibits travel',
    message => 'cannot travel from %{src}s to %{dest}s during %{event}s',
    data    => {
      src    => 'London',
      dest   => 'New York',
      event  => 'volcanic eruption',
    },
  });

  is(
    $error->message,
    'cannot travel from London to New York during volcanic eruption',
    'error message is formatted on demand',
  );

  jdiag( ppack( $error ));
}

done_testing;
