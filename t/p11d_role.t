use strict;
use warnings;
use Test::More;

use lib 't/lib';

use Stick::Util -all;
use PTest::P11dPublishedClass;

my $o = PTest::P11dPublishedClass->new() or die;
is($o->unpublished_method, "With your mouth");
is($o->published_method, "I like pie");

done_testing;
