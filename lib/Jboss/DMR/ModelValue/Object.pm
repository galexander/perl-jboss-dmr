package Jboss::DMR::ModelValue::Object;
use base qw(Jboss::DMR::ModelValue);
use strict;
use warnings;

use Jboss::DMR::ModelNode;

sub getChild {
    my $self = shift;
    my $name = shift;

    return undef
        unless defined $name;

    my $value = $self->getValue();

    return $value->{$name}
        if $value->{$name};

    my $node = Jboss::DMR::ModelNode->new();
    
    $value->{$name} = $node;
    $node;
}


sub removeChild {
    my $self = shift;
    my $name = shift;

    return undef
        unless defined $name;

    return delete $self->getValue()->{$name};
}


1;
