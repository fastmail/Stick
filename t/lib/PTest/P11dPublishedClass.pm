package PTest::P11dPublishedClass;
use Moose;
with ('PTest::Role::P11dPublishedMethod' => { slogan => "I like pie" });

1;
