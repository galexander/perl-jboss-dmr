package Jboss::DMR::ModelValue::BigNumber;
use base 'Jboss::DMR::ModelValue';

use strict;
use warnings;

use Jboss::DMR::ModelType qw(:bool);

sub asLong {
    return sprintf "%l", $_[0]->value->int_val;
}

sub asInt {
    return sprintf "%d", $_[0]->value->int_val;
}

sub asBigDecimal {
    return new JBoss::DMR::ModelValue::BigDecimal($_[0]->value)->value;
}

sub asBigInteger {
    return $_[0]->value;
}

sub asBoolean {
    return
        $_[0]->value->is_zero()
            ? false
            : true;
}

sub asDouble {
    return sprintf "%f", $_[0]->value;
}

sub asString {
    return $_[0]->bsstr;
}


1;
