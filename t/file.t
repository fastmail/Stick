use strict;
use warnings;
use Test::More;
use Test::Deep qw(cmp_deeply any array_each bool ignore);

use lib 't/lib';

use JSON 2;
use Stick::Util '-all';
use PTest::Dir;
use PTest::File;
use Scalar::Util qw(blessed);

my $JSON = JSON->new->ascii(1)->convert_blessed(1)->allow_blessed(1);

sub jenc  { $JSON->encode( ppack($_[0]) ) }
sub jrt   { $JSON->decode( jenc($_[0]) )  }
sub jdiag { note(jenc($_[0]))    }

sub flatpack {
  my ($entity) = @_;

  my $flat = $JSON->decode( $JSON->encode( ppack( $entity ) ) );
  return $flat->{value};
}

subtest "simple file that exists" => sub {
  my $file = PTest::File->new({ filename => 't/file.t' });

  my @methods = $file->meta->get_all_published_method_names;
  is_deeply(
    \@methods,
    [ qw(class) ],
    "file only publishes one method",
  );

  isa_ok($file, 'PTest::File');

  is(
    $file->class,
    'PTest::File',
    "the class method works via normal invocation",
  );

  is(
    flatpack($file->class),
    'PTest::File',
    "the class method works via packed round trip",
  );

  cmp_deeply(
    flatpack($file),
    {
      filename => 't/file.t',
      exists   => bool(1),
    },
    "the file packs how we'd expect",
  );

  is($file->data_mgr->size, -s 't/file.t', 'gets the right size');

  is(
    $file->data_mgr->size_plus({ plus => 1_000 }),
    (-s 't/file.t') + 1_000,
    'gets the right size_plus',
  );
};

subtest "simple file that doesn't exist" => sub {
  my $file = PTest::File->new({ filename => 't/bogus.txt' });

  isa_ok($file, 'PTest::File');

  cmp_deeply(
    flatpack($file),
    {
      filename => 't/bogus.txt',
      exists   => bool(0),
    },
    "the file packs how we'd expect",
  );

  is($file->data_mgr->size, undef, 'gets the right size (undef because !-e)');
};

subtest "simple directory" => sub {
  my $dir  = PTest::Dir->new({ dirname => 't' });

  isa_ok($dir, 'PTest::Dir');

  cmp_deeply(
    flatpack($dir),
    {
      dirname => 't',
      exists  => bool(1),
    },
    "the dir packs how we'd expect",
  );

  cmp_deeply(
    flatpack($dir->file_mgr->contents),
    array_each(
      any(
        { filename => ignore(), exists => ignore() },
        { dirname  => ignore(), exists => ignore() },
      )
    ),
    "dir->contents packs as expected",
  );

  cmp_deeply(
    flatpack($dir->file_mgr->tree),
    array_each(
      any(
        { filename => ignore(), exists => ignore() },
        [ ignore() ], # XXX: EXTREME BOGISTY -- rjbs, 2011-02-23
      ),
    ),
    "dir->tree packs as expected",
  );

  cmp_deeply(
    flatpack($dir->file_mgr->contains({ file => 't/file.t' })),
    bool(1),
    '->contains($contained) works',
  );

  cmp_deeply(
    flatpack($dir->file_mgr->contains({ file => 't/bogus.t' })),
    bool(0),
    '->contains($not_contained) works',
  );
};

done_testing;
