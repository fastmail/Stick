
use strict;
use warnings;
use Test::More;

use lib 't/lib';

use Stick::Util '-all';
use Stick::Types qw(StickBool OptionalStickBool);
use Stick::Entity::Bool;

subtest "simple file that exists" => sub {
  subtest "StickBool" => sub {
    ok(  StickBool->coerce(1), "coerced 1 to StickBool");
    ok(! StickBool->coerce(0), "coerced 0 to StickBool");
  };
  subtest "OptionalStickBool" => sub {
    ok(  OptionalStickBool->coerce(1), "coerced 1 to StickBool");
    ok(! OptionalStickBool->coerce(0), "coerced 0 to StickBool");
  };
};

done_testing;
