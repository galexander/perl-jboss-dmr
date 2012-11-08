package Jboss::DMR::ModelValue::Boolean;
use base 'Jboss::DMR::ModelValue';

use strict;
use warnings;

use Math::BigFloat;
use Math::BigInt;

use Jboss::DMR::ModelType qw(:bool);

use constant TRUE => Jboss::DMR::ModelValue::Boolean->new(true);
use constant FALSE => Jboss::DMR::ModelValue::Boolean->new(false);


sub asLong {
    $_->[0]->getValue() == true
        ? 1
        : 0;
}

sub asInt {
    $_->[0]->getValue() == true
        ? 1
        : 0;
}

sub asBoolean {
    $_[0]->getValue();
}

sub asDouble  { 
    $_->[0]->getValue() == true
        ? 1
        : 0;
}


sub asBytes {
    $_[0]->getValue() == true
        ? pack "C", 1
        : pack "C", 0;
}

sub asBigDecimal {
    $_[0]->getValue() == true
        ? Math::BigFloat->bone()
        : Math::BigFloat->bzero()
}


sub asBigInteger {
    $_[0]->getValue() == true
        ? Math::BigInt->bone()
        : Math::BigInt->bzero()
}

sub asString {
    $_[0]->getValue() == true
        ? "true"
        : "false";
}

sub ValueOf {
    my $value = shift;
    defined $value && $value == true
        ? TRUE->clone()
        : FALSE->clone();
}

1;
