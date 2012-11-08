#!/usr/bin/perl -w

use strict;
use warnings;
use lib 'lib';

use Test::More qw(no_plan);

# Standard
use_ok 'Jboss::DMR::ModelValue';
use_ok 'Jboss::DMR::ModelType';

# Import ModelType's
use Jboss::DMR::ModelType qw(:types :bool);

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

# Test Constructor
can_ok 'Jboss::DMR::ModelValue', 'new';

# Test Accessor/Mutator and Static Methods
can_ok 'Jboss::DMR::ModelValue', 'type';
can_ok 'Jboss::DMR::ModelValue', 'getType';
can_ok 'Jboss::DMR::ModelValue', 'getTypeName';
can_ok 'Jboss::DMR::ModelValue', 'validate';

can_ok 'Jboss::DMR::ModelValue', map("${_}Value", keys %TypeMap);
can_ok 'Jboss::DMR::ModelValue', map("as${_}",    keys %TypeMap);

can_ok 'Jboss::DMR::ModelValue', 'getChild';
can_ok 'Jboss::DMR::ModelValue', 'removeChild';
can_ok 'Jboss::DMR::ModelValue', 'addChild';
can_ok 'Jboss::DMR::ModelValue', 'getKeys';
can_ok 'Jboss::DMR::ModelValue', 'asType';
can_ok 'Jboss::DMR::ModelValue', 'clone';
can_ok 'Jboss::DMR::ModelValue', 'struct';
can_ok 'Jboss::DMR::ModelValue', 'asPropertyList';

TODO: {
    local $TODO = "not implemented yet";
can_ok 'Jboss::DMR::ModelValue', 'writeString';
can_ok 'Jboss::DMR::ModelValue', 'writeExternal';
can_ok 'Jboss::DMR::ModelValue', 'formatAsJSONString';
can_ok 'Jboss::DMR::ModelValue', 'writeJSONString';
can_ok 'Jboss::DMR::ModelValue', 'toJSONString';
can_ok 'Jboss::DMR::ModelValue', 'resolve';
can_ok 'Jboss::DMR::ModelValue', 'copy';
can_ok 'Jboss::DMR::ModelValue', 'has';
can_ok 'Jboss::DMR::ModelValue', 'requireChild';
}

# Test Exporter
use Jboss::DMR::ModelValue qw(:all);

can_ok 'main', map("${_}Value", keys %TypeMap);

eval { Jboss::DMR::ModelValue->new() };
ok defined $@, 'Jbmoss::DMR::ModelValue->new abstract constructor dies OK';

isa_ok (Jboss::DMR::ModelValue->BigDecimalValue(10),
       'Jboss::DMR::ModelValue::BigDecimal');
isa_ok (Jboss::DMR::ModelValue->BigIntegerValue(10),
       'Jboss::DMR::ModelValue::BigInteger');
isa_ok (Jboss::DMR::ModelValue->BooleanValue('true'),
       'Jboss::DMR::ModelValue::Boolean');
isa_ok (Jboss::DMR::ModelValue->BytesValue(\"10"),
       'Jboss::DMR::ModelValue::Bytes');
isa_ok (Jboss::DMR::ModelValue->DoubleValue(2*32+.4),
       'Jboss::DMR::ModelValue::Double');
isa_ok (Jboss::DMR::ModelValue->ExpressionValue("\$expression"),
       'Jboss::DMR::ModelValue::Expression');
isa_ok (Jboss::DMR::ModelValue->IntValue(10),
       'Jboss::DMR::ModelValue::Int');
isa_ok (Jboss::DMR::ModelValue->ListValue([]),
       'Jboss::DMR::ModelValue::List');
isa_ok (Jboss::DMR::ModelValue->LongValue(2**32),
       'Jboss::DMR::ModelValue::Long');
isa_ok (Jboss::DMR::ModelValue->ObjectValue(bless {},'Object'),
       'Jboss::DMR::ModelValue::Object');
TODO: {
    local $TODO = "To be implemented";
eval {
isa_ok (Jboss::DMR::ModelValue->PropertyValue({}),
       'Jboss::DMR::ModelValue::Property');
}
}
isa_ok (Jboss::DMR::ModelValue->StringValue("string"),
       'Jboss::DMR::ModelValue::String');
isa_ok (Jboss::DMR::ModelValue->UndefinedValue(undef),
       'Jboss::DMR::ModelValue::Undefined');

# Test ValueOf
{
    use bignum;
    isa_ok (Jboss::DMR::ModelValue->ValueOf(new Math::BigFloat(0.5+(2-2**-52)*2**1023)),
       'Jboss::DMR::ModelValue::BigDecimal');

    isa_ok (Jboss::DMR::ModelValue->ValueOf(new Math::BigFloat(2**-1075)),
       'Jboss::DMR::ModelValue::BigDecimal');

    isa_ok (Jboss::DMR::ModelValue->ValueOf(new Math::BigFloat(0.5+(2-2**-52)*2**1023)->bneg),
       'Jboss::DMR::ModelValue::BigDecimal');

    isa_ok (Jboss::DMR::ModelValue->ValueOf(new Math::BigFloat(2**-1075)->bneg),
       'Jboss::DMR::ModelValue::BigDecimal');

}

{
    use bignum;
    isa_ok (Jboss::DMR::ModelValue->ValueOf(new Math::BigFloat(1+(2-2**-52)*2**1023)),
       'Jboss::DMR::ModelValue::BigInteger');

    isa_ok (Jboss::DMR::ModelValue->ValueOf(new Math::BigFloat(1+(2-2**-52)*2**1023)->bneg),
       'Jboss::DMR::ModelValue::BigInteger');

}

isa_ok (Jboss::DMR::ModelValue->ValueOf(true),
       'Jboss::DMR::ModelValue::Boolean');

isa_ok (Jboss::DMR::ModelValue->ValueOf(\"bytes"),
       'Jboss::DMR::ModelValue::Bytes');

{
    use bignum;
    isa_ok (Jboss::DMR::ModelValue->ValueOf(new Math::BigFloat((2-2**-52)*2**1023)),
       'Jboss::DMR::ModelValue::Double');

    isa_ok (Jboss::DMR::ModelValue->ValueOf(new Math::BigFloat((2-2**-52)*2**1023)->bneg),
       'Jboss::DMR::ModelValue::Double');

    isa_ok (Jboss::DMR::ModelValue->ValueOf(new Math::BigFloat(2**-1074)),
       'Jboss::DMR::ModelValue::Double');

    isa_ok (Jboss::DMR::ModelValue->ValueOf(new Math::BigFloat(2**-1074)->bneg),
       'Jboss::DMR::ModelValue::Double');

    isa_ok (Jboss::DMR::ModelValue->ValueOf(new Math::BigInt(2**63)),
       'Jboss::DMR::ModelValue::Double');

    isa_ok (Jboss::DMR::ModelValue->ValueOf(new Math::BigInt((-2**63)-1)),
       'Jboss::DMR::ModelValue::Double');

    isa_ok (Jboss::DMR::ModelValue->ValueOf(new Math::BigInt(2.5)),
       'Jboss::DMR::ModelValue::Double');
}


# no auto expression detection

isa_ok (Jboss::DMR::ModelValue->ValueOf(0),
       'Jboss::DMR::ModelValue::Int');

isa_ok (Jboss::DMR::ModelValue->ValueOf((2**31)-1),
       'Jboss::DMR::ModelValue::Int');

isa_ok (Jboss::DMR::ModelValue->ValueOf(-(2**31)),
       'Jboss::DMR::ModelValue::Int');

isa_ok (Jboss::DMR::ModelValue->ValueOf([]),
       'Jboss::DMR::ModelValue::List');

{
    use bignum;
    isa_ok (Jboss::DMR::ModelValue->ValueOf(new Math::BigInt((2**63)-1)),
           'Jboss::DMR::ModelValue::Long');

    isa_ok (Jboss::DMR::ModelValue->ValueOf(new Math::BigInt(-(2**63))),
           'Jboss::DMR::ModelValue::Long');
}

isa_ok (Jboss::DMR::ModelValue->ValueOf(2**32),
       'Jboss::DMR::ModelValue::Long');

isa_ok (Jboss::DMR::ModelValue->ValueOf(-(2**32)-1),
       'Jboss::DMR::ModelValue::Long');

isa_ok (Jboss::DMR::ModelValue->ValueOf(bless {},'Object'),
       'Jboss::DMR::ModelValue::Object');

isa_ok (Jboss::DMR::ModelValue->ValueOf({}),
       'Jboss::DMR::ModelValue::Object');

isa_ok (Jboss::DMR::ModelValue->ValueOf("string"),
       'Jboss::DMR::ModelValue::String');

isa_ok (Jboss::DMR::ModelValue->UndefinedValue(undef),
       'Jboss::DMR::ModelValue::Undefined');


for (keys %TypeMap) {

    eval "Jboss::DMR::ModelValue->as${_}";
    
like $@, qr/illegal/i, "as$_ accessor died OK";

}

for (qw(getChild removeChild addChild getKeys asType asPropertyList asList)) {
    eval "Jboss::DMR::ModelValue->${_}";
    
like $@, qr/illegal/i, "$_ accessor died OK";

}

# Test Clone
my $test  = IntValue(42);
my $clone = $test->clone;
is $test->value, 42, "Test value set OK";
is $clone->value, $test->value, "Clone value OK";
is_deeply $clone, $test, "Deep clone looks good";

# Test Struct
my $struct = ListValue([1,2,3,4]);
is_deeply $struct->struct, [1,2,3,4], 'struct returned correct result';

