use strict;
use warnings;
use Test::Deep qw(cmp_deeply any array_each bool ignore);
use Test::More;
use Test::Fatal;

use lib 't/lib';

use PTest::Nonproductive;
use Scalar::Util qw(blessed);

subtest "non-productive routing fails" => sub {
  plan tests => 3;
  my $test = PTest::Nonproductive->new({ productive => 0 });
  my $exc = exception { $test->route(['foo']) };
  ok($exc);
  if ($exc) {
    isa_ok($exc, "Stick::Error");
    like($exc->ident, qr/non-productive routing/, "recognize ident");
  }
};

subtest "non-productive routing can be made to succeed" => sub {
  my $test = PTest::Nonproductive->new({ productive => 0 });
  ok(! exception { $test->route(['ok']) });
  ok(  exception { $test->route(['fail']) }, "make sure ndr_ok is not sticky");
};

done_testing;
