#!usr/bin/perl -w

use strict;
use warnings;
use Test::More tests => 18;

use lib 'lib';
use_ok 'Jboss::DMR::ModelType';

use Jboss::DMR::ModelType qw(:types :bool);

for (qw(
    BIG_DECIMAL
    BIG_INTEGER
    BOOLEAN
    BYTES
    DOUBLE
    EXPRESSION
    INT
    LIST
    LONG
    OBJECT
    PROPERTY
    STRING
    UNDEFINED)) {

can_ok 'main', $_;

}

can_ok 'main', 'true';
can_ok 'main', 'false';

isa_ok true, 'Jboss::DMR::ModelType::Boolean';
isa_ok false, 'Jboss::DMR::ModelType::Boolean';
