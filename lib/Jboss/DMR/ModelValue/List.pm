package Jboss::DMR::ModelValue::List;
use base qw(Jboss::DMR::ModelValue);
use strict;
use warnings;

sub getChild {
    my $self = shift;
    my $index = shift;
    my $value = $self->getValue();
    my $size  = scalar @$value;
    if ($size <= $index) {
        for (my $i = 0; $i < $index - $size; $i++) {
            push @$value, Jboss::DMR::ModelNode->new();
        }
    }
    return $value->[$index];
}

sub addChild {
    my $self = shift;
    my $node = Jboss::DMR::ModelNode->new();
    push @{$self->getValue()}, $node;
    return $node;
}
1;
