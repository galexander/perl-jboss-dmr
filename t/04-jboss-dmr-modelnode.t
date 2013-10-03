#!/usr/bin/perl -w 

use strict;
use warnings;

use lib 'lib';

# Import ModelType's
use Jboss::DMR::ModelType qw(:types :bool);
use Jboss::DMR::ModelValue qw(:values);

use Test::More qw(no_plan);

my %TypeMap = (
    BigDecimal  => BIG_DECIMAL,
    BigInteger  => BIG_INTEGER,
    Boolean     => BOOLEAN,
    Bytes       => BYTES,
    Double      => DOUBLE,
    Expression  => EXPRESSION,
    Int         => INT,
    List        => LIST,
    Long        => LONG,
    Object      => OBJECT,
    Property    => PROPERTY,
    String      => STRING,
    Undefined   => UNDEFINED,
);

use_ok 'Jboss::DMR::ModelNode';
can_ok 'Jboss::DMR::ModelNode', 'value';
can_ok 'Jboss::DMR::ModelNode', 'isDefined';
can_ok 'Jboss::DMR::ModelNode', map("as${_}", keys %TypeMap);

# test constructors

isa_ok (Jboss::DMR::ModelNode->new(BigDecimalValue("123"))->value,
        'Jboss::DMR::ModelValue::BigDecimal');

isa_ok (Jboss::DMR::ModelNode->new(BigIntegerValue("456"))->value,
        'Jboss::DMR::ModelValue::BigInteger');

isa_ok (Jboss::DMR::ModelNode->new(BooleanValue(true))->value,
        'Jboss::DMR::ModelValue::Boolean');

isa_ok (Jboss::DMR::ModelNode->new(BytesValue(\"abcd"))->value,
        'Jboss::DMR::ModelValue::Bytes');

isa_ok (Jboss::DMR::ModelNode->new(DoubleValue("123"))->value,
        'Jboss::DMR::ModelValue::Double');

isa_ok (Jboss::DMR::ModelNode->new(ExpressionValue('$expression'))->value,
        'Jboss::DMR::ModelValue::Expression');

isa_ok (Jboss::DMR::ModelNode->new(IntValue("123"))->value,
        'Jboss::DMR::ModelValue::Int');

isa_ok (Jboss::DMR::ModelNode->new(ListValue([]))->value,
        'Jboss::DMR::ModelValue::List');

isa_ok (Jboss::DMR::ModelNode->new(LongValue([]))->value,
        'Jboss::DMR::ModelValue::Long');

isa_ok (Jboss::DMR::ModelNode->new(ObjectValue({}))->value,
        'Jboss::DMR::ModelValue::Object');

#SKIP: {
#    skip "This dies - fixme", 1;
isa_ok (Jboss::DMR::ModelNode->new(PropertyValue("foo", BooleanValue(true)))->value,
        'Jboss::DMR::ModelValue::Property');
#}

isa_ok (Jboss::DMR::ModelNode->new(StringValue("string"))->value,
        'Jboss::DMR::ModelValue::String');

isa_ok (Jboss::DMR::ModelNode->new(UndefinedValue(undef))->value,
        'Jboss::DMR::ModelValue::Undefined');

isa_ok (Jboss::DMR::ModelNode->new()->value,
        'Jboss::DMR::ModelValue::Undefined');

my $node = Jboss::DMR::ModelNode->new();
isa_ok $node, 'Jboss::DMR::ModelNode';
isa_ok $node->value, 'Jboss::DMR::ModelValue::Undefined';
ok !$node->isDefined(), '$node set to undefined correctly';
