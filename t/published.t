use strict;
use warnings;
use Test::More;

use lib 't/lib';

use Stick::Util -all;
use PTest::Dir;
use PTest::File;
use Test::Deep;

{
  my $meta  = PTest::Dir->new({ dirname => 't' })->file_mgr->meta;
  cmp_deeply([$meta->get_all_published_method_names],
             bag(qw(contents tree contains)),
             "get all published method names");
  cmp_ok($meta->get_all_published_methods, '<', $meta->get_all_methods);
}

{
  my $meta = PTest::File->new({ filename => 't/file.t' })->data_mgr->meta;
  cmp_deeply([$meta->get_all_published_method_names],
             bag(qw(size size_plus)),
             "get all published method names");
  cmp_ok($meta->get_all_published_methods, '<', $meta->get_all_methods);
}

done_testing;
