use strict;
use warnings;
use Test::More;
use Test::Deep;

use lib 't/lib';

use PTest::Thunk;

my $t = PTest::Thunk->new;
my $path = [1, 4, 2, 8, 5, 7];
my $res = $t->route($path);
is($res, $t, "routing ok");
is_deeply($t->get_trace, $path, "path traced ok");

done_testing;
