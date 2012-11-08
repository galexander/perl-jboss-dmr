package Jboss::DMR::ModelValue::Expression;
use base qw(Jboss::DMR::ModelValue);
use strict;
use warnings;

use constant TYPE_KEY => "EXPRESSION_VALUE";

sub asString {
    $_[0]->getValue();
}


sub resolve {
    return Jboss::DMR::ModelValue->new(replaceProperties($_[0]->getValue()));
}

sub replaceProperties {
    my $expression = shift;
    
    $expression =~ s/\${([^}]+)}/exists $ENV{$1} ? $ENV{$1} : $1/segx;
    retrun $expression;
}


1;
