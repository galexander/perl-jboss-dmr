package Jboss::DMR::ModelValue::BigDecimal;
use base 'Jboss::DMR::ModelValue::BigNumber';

use Jboss::DMR::ModelType qw(:bool);

use Math::BigFloat;

use strict;
use warnings;

sub new {
    my $class = shift;
    my $value = shift;
    
    $value = Math::BigFloat->new("$value")
        unless ref $value and UNIVERSAL::isa($value, qw(Math::BigFloat));

    my $self = $class->SUPER::new($value);
    $self;
}

sub asBigInteger {
    $_[0]->value->as_int;
}

sub asInt {
    return sprintf "%d", $_[0]->value->as_int->as_int;
}

sub asLong {
    return sprintf "%l", $_[0]->value->as_int->as_int;
}


1;
