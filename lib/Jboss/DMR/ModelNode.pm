package Jboss::DMR::ModelNode;

use strict;
use warnings;
use Scalar::Util qw(blessed reftype);
use Storable qw(dclone);

use Carp qw(croak);
use JSON qw(to_json);

use Jboss::DMR::ModelType qw(:types);
use Jboss::DMR::ModelValue;

sub new {
    my $class = shift;
    my $value = shift;
    my $self = bless {}, ref $class || $class;
    $self->set($value);
    $self;
}

sub type {
    return $_[0]->value->type;
}

sub getType {
    return $_[0]->value->getType();
}

sub set {
    my $self  = shift;
    my $value = shift;
    my $model_value;
    if (defined $value) {
        if (blessed $value) {
            if ($value->isa('Jboss::DMR::ModelValue')) {
                $model_value = $value;
            } else {
                croak "Invalid model value for set @{[ reftype $value ]}";
            }

        } else {
            $model_value = Jboss::DMR::ModelValue->valueOf($value);
        }

    } else {
        $model_value = Jboss::DMR::ModelValue::Undefined->new();
    }
    $self->{'_value'} = $model_value;
    $self->{'_value'};
}

sub clone {
    my $self = shift;
    return bless (dclone $self), ref $self;
}

sub setBigDecimal {
    my $self = shift;
    $self->set(bigDecimalValue(@_));
}

sub setBigInteger {
    my $self = shift;
    $self->set(bigIntegerValue(@_));
}

sub setBoolean {
    my $self = shift;
    $self->set(booleanValue(@_));
}

sub setBytes {
    my $self = shift;
    $self->set(bytesValue(@_));
}

sub setDouble {
    my $self = shift;
    $self->set(doubleValue(@_));
}

sub setExpression {
    my $self = shift;
    $self->set(expressionValue(@_));
}

sub setInt {
    my $self = shift;
    $self->set(intValue(@_));
}

sub setList {
    my $self = shift;
    $self->set(listValue(@_));
}

sub setLong {
    my $self = shift;
    $self->set(longValue(@_));
}

sub setObject {
    my $self = shift;
    $self->set(objectValue(@_));
}

sub setProperty {
    my $self = shift;
    $self->set(propertyValue(@_));
}

sub setString {
    my $self = shift;
    $self->set(stringValue(@_));
}

sub setUndefined {
    my $self = shift;
    $self->set(undefinedValue(@_));
}

1;
