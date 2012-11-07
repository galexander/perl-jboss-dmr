package Jboss::DMR::ModelValue::BigInteger;
use base 'Jboss::DMR::ModelValue::BigNumber';

use strict;
use warnings;

use Math::BigInt;

sub new {
    my $class = shift;
    my $value = shift;

    $value = Math::BigInt->new("$value")
        unless ref $value and UNIVERSAL::isa($value, qw(Math::BigInt));
        
    $value = $value->as_int
        if ref $value and UNIVERSAL::isa($value, qw(Math::BigFloat));

    my $self = $class->SUPER::new($value);
    $self;
}



1;
