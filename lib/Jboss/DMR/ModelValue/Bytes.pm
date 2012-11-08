package Jboss::DMR::ModelValue::Bytes;
use base qw(Jboss::DMR::ModelValue);
use strict;
use warnings;

use constant TYPE_KEY => 'BYTES_VALUE';

sub asLong {
    pack "l", $_[0]->getValue();
}

sub asInt {
    pack "i", $_[0]->getValue();
}

sub asDouble {
    pack "d", $_[0]->getValue();
}

sub asBigDecimal {
    Math::BigFloat->new($_[0]->getValue());
}

sub asBigInteger {
    Math::BigInt->new($_[0]->getValue());
}

sub asBytes {
    $_[0]->getValue();
}

sub asString {
    return sprintf "%s", $_[0]->getValue();
}


1;
