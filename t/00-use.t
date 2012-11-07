#!/usr/bin/perl -w

use strict;
use warnings;

use Test::More tests => 17;

use lib 'lib';
use_ok 'Jboss::DMR';
use_ok 'Jboss::DMR::ModelType';
use_ok 'Jboss::DMR::ModelNode';
use_ok 'Jboss::DMR::ModelValue';
for (qw(
    BigDecimal
    BigInteger
    Boolean
    Bytes
    Double
    Expression
    Int
    List
    Long
    Object
    Property
    String
    Undefined)) {

use_ok "Jboss::DMR::ModelValue::${_}";

}
