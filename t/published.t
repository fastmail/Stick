use strict;
use warnings;
use Test::More;

use lib 't/lib';

use Stick::Util -all;
use PTest::Datum;
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

subtest "published attrs" => sub {
  my $datum = PTest::Datum->new({
    pub_ro => 123,
  });

  isa_ok($datum, 'PTest::Datum');

  my @attr = $datum->meta->get_all_published_attributes;

  is_deeply(
    [ map {; $_->name } @attr ],
    [ qw(pub_ro) ],
    "the right attributes seem published",
  );

  my $attr = $datum->meta->attribute_published_under_path('pub_ro');
  isa_ok($attr, 'Moose::Meta::Attribute', 'attr published as pub_ro');

  my $resource = $datum->route([ 'pub_ro' ]);
  isa_ok($resource, 'Stick::WrappedMethod');

  is(
    $resource->resource_request('get'),
    $datum->pub_ro,
    "we can 'GET' the value out of the reader",
  );
};

done_testing;
