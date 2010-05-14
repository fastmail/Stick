use strict;
use warnings;
use Test::More;

use lib 't/lib';

use JSON 2;
use PTest::File;
use Scalar::Util qw(blessed);

my $JSON = JSON->new->ascii(1)->convert_blessed(1)->allow_blessed(1);

sub TOP_LEVEL_PRISM_PACK {
  return { value => $_[0] } unless ref $_[0];
  return $_[0] if ref $_[0] and not blessed $_[0];
  return $_[0]->PRISM_PACK if $_[0]->can('PRISM_PACK');
  die "no route to pack";
}

{
  my $file = PTest::File->new({ filename => 't/file.t' });
  my $pack = TOP_LEVEL_PRISM_PACK($file);

  diag($JSON->encode($pack));

  diag($JSON->encode( TOP_LEVEL_PRISM_PACK( $file->data_mgr->size )));
}

{
  my $file = PTest::File->new({ filename => 't/bogus.txt' });
  my $pack = $file->PRISM_PACK;

  diag($JSON->encode($pack));
}

done_testing;
