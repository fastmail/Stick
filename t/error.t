use strict;
use warnings;
use Test::More;

use lib 't/lib';

use JSON 2 ();
use Stick::Util qw(json_pack ppack);
use Stick::Error;

use Test::Deep qw(cmp_deeply superhashof);

my $JSON = JSON->new->ascii(1)->convert_blessed(1)->allow_blessed(1);

sub flatpack {
  my ($entity) = @_;

  my $flat = $JSON->decode( json_pack( $entity ) );
  return $flat->{value};
}

subtest "private error" => sub {
  my $error = Stick::Error->new({
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

  cmp_deeply(
    flatpack($error),
    superhashof({
      ident   => 'internal error',
      message => 'an internal error occurred',
      data    => { },
    }),
  );
};

subtest "public error" => sub {
  my $error = Stick::Error->new({
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

  cmp_deeply(
    flatpack($error),
    superhashof({
      ident   => 'event prohibits travel',
      message => 'cannot travel from %{src}s to %{dest}s during %{event}s',
      data    => {
        src    => 'London',
        dest   => 'New York',
        event  => 'volcanic eruption',
      }
    }),
  );
};

subtest "one-arg new" => sub {
  my $MSG = "with your mouth";
  my $error = Stick::Error->new($MSG);
  is($error->message, $MSG, "message");
  is($error->ident, $MSG, "ident");
  ok(! $error->public);
};

done_testing;
