package Jboss::DMR::ModelValue::Long;
use base qw(Jboss::DMR::ModelValue);
use strict;
use warnings;
use bignum;

use Math::BigInt qw(:constant);

use constant MIN_LONG_VAL => new Math::BigInt(2**63)->bneg;
use constant MAX_LONG_VAL => new Math::BigInt((2**63)-1);

our @EXPORT_OK   = qw(MAX_LONG_VAL MIN_LONG_VAL ValidLong);
our %EXPORT_TAGS = (
    constant => [qw(MAX_LONG_VAL MIN_LONG_VAL)],
    validate => [qw(ValidLong)]
);

sub ValidLong {
    my $value = new Math::BigInt(pop @_);
#print "$value cmp @{[ MIN_LONG_VAL ]} = @{[ $value->bcmp(MIN_LONG_VAL) ]}\n";
# print "$value @{[ MAX_LONG_VAL ]} = @{[ $value->bcmp(MAX_LONG_VAL) ]}\n";
    return 0 if $value->bcmp(MIN_LONG_VAL) < 0;
#print "$value cmp @{[ MAX_LONG_VAL ]} =  @{[ $value->bcmp(MAX_LONG_VAL) ]}\n";
    return 1 if $value->bcmp(MAX_LONG_VAL) <= 0; 
    return 0;
}

1;
