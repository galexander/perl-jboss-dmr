package Jboss::DMR::ModelValue::Property;
use base qw(Jboss::DMR::ModelValue);
use strict;
use warnings;

use Carp qw(croak);
use Scalar::Util qw(blessed looks_like_number);

use Jboss::DMR::Property ();

use constant TYPE_KEY => "PROPERTY_TYPE";

sub new {
    my $class = shift;
    
    my $property;

    if (scalar @_ == 1) {
        croak "Invalid argument in constructor (@{[ ref $_[0]  || $_[0] ]})"
            unless blessed $_[0] and $_[0]->isa('Jboss::DMR::Property');

        $property = shift @_;

    } else {

        $property = Jboss::DMR::Property->new(@_);
    }

    my $self = $class->SUPER::new($property);
    $self;
}

sub asProperty {
    $_[0]->getValue();
}

sub asPropertyList {
    [ $_[0]->getValue() ];
}

sub asObject {
    my $node = Jboss::DMR::ModelNode->new;
    my $property = $_[0]->getValue();
    $node->get($property->getName())->set($property->getValue());
    $node;
}

sub getKeys {
    ($_[0]->getName());
}

sub asList {
    [ Jboss::DMR::ModeNode->new($_[0]) ];
}

sub getChild {
    my $property = $_[0]->getValue();
    if (looks_like_number $_[1]) {
        return $_[0]
            ? $property->getValue()
            : $_[0]->SUPER::getChild($_[1]);

    } else {
        return $property->getName() eq $_[1]
            ? $property->getValue()
            : $_[0]->SUPER::getChild($_[1]);
    }
}

sub copy {
    my $self = shift;
    my $property = $self->getValue();
    $self->new($property->getName(), $property->getValue());
}

sub resolve {
    my $self = shift;
    my $property = $self->getValue();
    $self->new($property->getName(), $property->getValue()->resolve());
}

1;
