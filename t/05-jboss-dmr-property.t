#!/usr/bin/perl -w

use strict;
use warnings;
use lib 'lib';

use Test::More qw(no_plan);
use Scalar::Util qw(refaddr);

use_ok 'Jboss::DMR::Property';

# Test methods
can_ok 'Jboss::DMR::Property', 'new';
can_ok 'Jboss::DMR::Property', 'getName';
can_ok 'Jboss::DMR::Property', 'getValue';
can_ok 'Jboss::DMR::Property', 'clone';

# Test Invalid constructor
my $property = eval { Jboss::DMR::Property->new("name", 1, 2, 3) };
ok defined $@, "Invalid constructor (count) identified";

$property = eval { Jboss::DMR::Property->new("name", (bless { } => 'Foo')) };
ok defined $@, "Invalid constructor (count) identified";

# Test defined constructor
$property = Jboss::DMR::Property->new("name",
    Jboss::DMR::ModelNode->new(
        Jboss::DMR::ModelValue::Double->new(1234),
    )
);
isa_ok $property,                 'Jboss::DMR::Property';
is     $property->getName,        'name','name set correctly in constructor';
isa_ok $property->getValue,       'Jboss::DMR::ModelNode';
isa_ok $property->getValue->value,'Jboss::DMR::ModelValue::Double';;
is     $property->getValue->value->value() ,1234,'value set correctly in constructor';


# Test auto constructor (Int)
$property = Jboss::DMR::Property->new("name", "123");
isa_ok $property,                 'Jboss::DMR::Property';
is     $property->getName,        'name','name set correctly in constructor';
isa_ok $property->getValue,       'Jboss::DMR::ModelNode';
isa_ok $property->getValue->value,'Jboss::DMR::ModelValue::Int';
is     $property->getValue->value->value() ,123,'value set correctly in constructor';


# Test auto constructor
my $map = { a => 1, b => 2 };
$property = Jboss::DMR::Property->new("name", $map);
isa_ok $property,                 'Jboss::DMR::Property';
is     $property->getName,        'name','name set correctly in constructor';
isa_ok $property->getValue,       'Jboss::DMR::ModelNode';
isa_ok $property->getValue->value,'Jboss::DMR::ModelValue::Object';
is_deeply $property->getValue->value->value() , $map, 'value set correctly in constructor';


# Test Clone
my $propertyValue = Jboss::DMR::ModelNode->new("value");
my $stringPropertyValue = $propertyValue->value;
$property = Jboss::DMR::Property->new('name', $propertyValue);

is ((refaddr $propertyValue), (refaddr $property->getValue),
        "model node references the same object");

is ((refaddr $stringPropertyValue), (refaddr $property->getValue->value),
        "model node value references the same object");

my $clone = $property->clone;
isa_ok $clone,                 'Jboss::DMR::Property';
is     $clone->getName,        'name','name set correctly in constructor';
isa_ok $clone->getValue,       'Jboss::DMR::ModelNode';
isa_ok $clone->getValue->value,'Jboss::DMR::ModelValue::String';
is     $clone->getValue->value->value() ,'value','value set correctly in constructor';
is_deeply $clone, $property, "cloned correctly";
ok     ((refaddr $propertyValue) ne (refaddr $clone->getValue),
            'cloned propertyValue correctly');
ok     ((refaddr $stringPropertyValue) ne (refaddr $clone->getValue->value),
            'cloned stringPropertyValue correctly');


# Test copy constructor
$propertyValue = Jboss::DMR::ModelNode->new("value");
$stringPropertyValue = $propertyValue->value;
$property = Jboss::DMR::Property->new('name', $propertyValue, 1);

ok ((refaddr $propertyValue) ne (refaddr $property->getValue),
        "model node references different objects");

ok ((refaddr $stringPropertyValue) ne (refaddr $property->getValue->value),
        "model node value references different objects");

is_deeply $property->getValue, $propertyValue,
    "copy constructor correct for propertyValue";
is_deeply $property->getValue->value, $stringPropertyValue,
    "copy constructor correct for stringPropertyValue";

1;
