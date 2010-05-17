use strict;
use warnings;
use Test::More;

use lib 't/lib';

use JSON 2;
use Prism::Util -all;
use PTest::Dir;
use PTest::File;
use Scalar::Util qw(blessed);

my $JSON = JSON->new->ascii(1)->convert_blessed(1)->allow_blessed(1);

sub jenc  { $JSON->encode( ppack($_[0]) ) }
sub jrt   { $JSON->decode( jenc($_[0]) ) }
sub jdiag { diag(jenc($_[0]))    }

{
  my $file = PTest::File->new({ filename => 't/file.t' });

  jdiag($file);

  jdiag($file->data_mgr->size);

  jdiag($file->data_mgr->size_plus({ plus => 1_000 }));
}

{
  my $file = PTest::File->new({ filename => 't/bogus.txt' });

  jdiag($file);
}

{
  my $dir  = PTest::Dir->new({ dirname => 't' });

  jdiag($dir);

  jdiag($dir->file_mgr->contents);

  jdiag($dir->file_mgr->tree);
}

{
  my $rv = PTest::Dir->new({ dirname => 't' })->file_mgr
                     ->contains({ file => 't/file.t' });

  jdiag($rv);
}

{
  my $rv = PTest::Dir->new({ dirname => 't' })->file_mgr
                     ->contains({ file => 't/doot.t' });

  jdiag($rv);
}

done_testing;
