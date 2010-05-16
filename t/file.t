use strict;
use warnings;
use Test::More;

use lib 't/lib';

use JSON 2;
use Prism::Util qw(ppack);
use PTest::Dir;
use PTest::File;
use Scalar::Util qw(blessed);

my $JSON = JSON->new->ascii(1)->convert_blessed(1)->allow_blessed(1);

sub jdiag { diag($JSON->encode($_[0])) }

{
  my $file = PTest::File->new({ filename => 't/file.t' });
  my $pack = ppack($file);

  jdiag($pack);

  jdiag( ppack( $file->data_mgr->size ));

  jdiag( ppack( $file->data_mgr->size_plus({ plus => 1_000 }) ));
}

{
  my $file = PTest::File->new({ filename => 't/bogus.txt' });
  my $pack = ppack($file);

  jdiag($pack);
}

{
  my $dir  = PTest::Dir->new({ dirname => 't' });
  my $pack = ppack($dir);

  jdiag($pack);

  jdiag( ppack($dir->file_mgr->contents) );

  jdiag( ppack($dir->file_mgr->tree) );
}

done_testing;
