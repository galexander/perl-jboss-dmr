package Jboss::DMR::ModelNode;

use strict;
use warnings;

our $VERSION = 0.00001;

use Scalar::Util qw(blessed reftype);
use Storable qw(dclone);

use Carp qw(croak);
use JSON qw(to_json);
use Exporter qw(import);

use constant ModelNode => 'Jboss::DMR::ModelNode';

our @EXPORT_OK = (qw(ModelNode));
our %EXPORT_TAGS = ( namespace => [qw(ModelNode)] );

use Jboss::DMR::ModelType qw(:types :typenames);

{
    no strict 'refs';

    my @exclude = ( qw(setExpression asList) );

    for my $type (@TYPE_NAMES) {
        my $typeAccessor = "as${type}";
        my $typeSetter   = "set${type}";
        my $typeConstructor = "Jboss::DMR::ModelValue::${type}";

        unless (grep $typeAccessor, @exclude) {
            *$typeAccessor = sub {
                my $self = shift;
                return $self->$typeAccessor(@_);
            };
        }

        eval "use $typeConstructor;";
        die "$@" if $@;

        unless (grep $typeSetter, @exclude) {
            *$typeSetter = sub {
                my $self = shift;
                return $self->$typeSetter($typeConstructor->new(@_));
            };
        }
    }
}

sub new {
    my $class = shift;
    my $self = bless {}, ref $class || $class;
    $self->set(@_);
    $self;
}

sub value {
    my $self = shift;
    if (scalar @_) {
        $self->set(@_);
    }
    $self->{'_value'};
}

sub getValue {
    $_[0]->{'_value'};
}

sub _setMulti {
    my $self = shift;

    my $propertyName  = shift;
    my $propertyValue = shift;

    my $node = $self->new($propertyValue);
    $self->{'_value'} = Jboss::DMR::ModelValue::Property->new($propertyName, $node);
    $self;
}

sub set {
    my $self  = shift;

    return $self->_setMulti(@_)
        if (scalar @_ >= 2);

    if (blessed $_[0] and $_[0]->isa('Jboss::DMR::Property')) {
         $self->_setMulti($_[0]->getName(), $_[0]->getValue());
    } else {
        $self->{'_value'} = Jboss::DMR::ModelValue->ValueOf(scalar @_ ? @_ : undef);
    }
    $self;
}

{
no warnings 'redefine';
sub setExpression {
    my $self = shift;

    my $propertyName  = shift;
    my $propertyValue = shift;

    my $node = $self->new($propertyValue);
    $self->{'_value'} = Jboss::DMR::ModelValue::Property->new($propertyName, $node);
    $self;
}
}

sub setEmptyList {
    my $self = shift;
    $self->set(Jboss::DMR::ModelValue::List->new([]));
    $self;
}

sub setEmptyObject {
    my $self = shift;
    $self->set(Jboss::DMR::ModelValue::Object->new({}));
    $self;
}

sub clear {
    my $self = shift;
    $self->set(Jboss::DMR::ModelValue::Undefined->new());
}

sub get {
    my $self = shift;

    if (scalar @_ == 1) {
        my $name = shift;
        my $value = $self->getValue();

    
        if ($value->type == UNDEFINED) {
            $value = Jboss::DMR::ModelValue::Object->new({});
            $self->set($value);
            return $value->getChild($name);
        } else {
            return $value->getChild($name);
        }
    } else {
        my $current = $self;
        for my $part (@_) {
            $current = $current->get($part);
        }
        return $current;
    }
}

sub add {
    my $self = shift;
    unless (scalar @_) {
        my $value = $self->getValue();
        if ($value->type == UNDEFINED) {
            $value = Jboss::DMR::ModelValue::List->new([]);
            $self->set($value);
            return $value->addChild();
        } else {
            return $value->addChild();
        }
    } else {
        $self->add()->set(@_);
        return $self;
    }
}

sub addEmptyList() {
    my $node = $_[0]->add();
    $node->setEmptyList();
    return $node;
}

sub addEmptyObject() {
    my $node = $_[0]->add();
    $node->setEmptyObject();
    return $node;
}

sub getKeys {
    $_[0]->getValue()->getKeys();
}

{
no warnings 'redefine';
sub asList {
    $_[0]->getValue()->asList();
}
}


sub clone {
    return bless dclone $_[0], ref $_[0] || $_[0]
}

sub isDefined {
    my $self  = shift;
    my $value = $self->value;
    return $value->type != UNDEFINED;
}

sub TO_JSON {
    my $self = shift;
    my $value = $self->getValue();
    if (blessed $value) {
        if ($value->isa('Jboss::DMR::ModelValue')) {
            return $value->getValue();
        } else {
            warn "Unknown type for json @{[ ref $value ]}\n";
            return undef;
        }
    } else {
        return $value;
    }
}
1;
