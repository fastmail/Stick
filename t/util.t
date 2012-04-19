use strict;
use warnings;
use Test::More;
use Stick::Util qw(true false);

(true)  ? pass("true is true")   : fail("true is true");
(false) ? fail("false is false") : pass("false is false");

(! false) ? pass("!false is true") : fail("!false is true");
(! true)  ? fail("!true is false") : pass("!true is false");

isa_ok((   true), 'Stick::Entity::Bool');
isa_ok((!  true), 'Stick::Entity::Bool');
isa_ok((  false), 'Stick::Entity::Bool');
isa_ok((! false), 'Stick::Entity::Bool');

done_testing;
