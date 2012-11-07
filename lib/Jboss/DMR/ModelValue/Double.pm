package Jboss::DMR::ModelValue::Double;
use base qw(Jboss::DMR::ModelValue);
use strict;
use warnings;
use bignum;

use Exporter qw(import);
use Math::BigFloat qw(:constant);

# We use Java limits
# http://docs.oracle.com/javase/specs/jls/se7/html/jls-4.html#jls-4.2.3
use constant MIN_DOUBLE_VAL => Math::BigFloat->new(2**-1074);;
use constant MAX_DOUBLE_VAL => Math::BigFloat->new((2-2**-52)*2**1023);

our @EXPORT_OK   = qw(MAX_DOUBLE_VAL MIN_DOUBLE_VAL ValidDouble);
our %EXPORT_TAGS = (
    constant => [qw(MAX_DOUBLE_VAL MIN_DOUBLE_VAL)],
    validate => [qw(ValidDouble)]
);

sub ValidDouble {
    my $value = new Math::BigFloat(pop @_);
#print "$value, @{[MIN_DOUBLE_VAL]}\n";
#printf "CMP = %d\n", $value->bcmp(MIN_DOUBLE_VAL);
#print "\n";
    return 0 if $value->bacmp(MIN_DOUBLE_VAL) < 0;
    return 0 if $value->bacmp(MAX_DOUBLE_VAL) > 0;
    return 1;
}


1;
