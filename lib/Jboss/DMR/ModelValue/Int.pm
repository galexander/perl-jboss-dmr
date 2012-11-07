package Jboss::DMR::ModelValue::Int;
use base qw(Jboss::DMR::ModelValue);
use strict;
use warnings;
use Exporter qw(import);

use constant MIN_INT_VAL => -2**31;
use constant MAX_INT_VAL =>  2**31-1;

our @EXPORT_OK   = qw(MAX_INT_VAL MIN_INT_VAL ValidInt);
our %EXPORT_TAGS = (
    constant => [qw(MAX_INT_VAL MIN_INT_VAL)],
    validate => [qw(ValidInt)]
);

sub ValidInt {
    my $value = pop @_;
    return $value >= MIN_INT_VAL && $value <= MAX_INT_VAL;
}



1;
