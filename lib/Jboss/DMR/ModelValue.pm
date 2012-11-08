package Jboss::DMR::ModelValue;
use strict;
use warnings;
use Carp qw(croak);
use Math::BigInt;
use Math::BigFloat;
use Scalar::Util qw(looks_like_number blessed);
use Storable qw(dclone);
use Exporter qw(import);

use Jboss::DMR::ModelType qw(:types :typenames);

our @EXPORT_OK;
our %EXPORT_TAGS;

{

    for my $type (@TYPE_NAMES) {

        my $subClass               = "@{[__PACKAGE__]}\::${type}";
        my $subClassConstructor     = "${type}Value";
        my $subStaticConstructor    = "${type}";
        my $subAccessor             = "as${type}";

        push @EXPORT_OK,              $subClassConstructor;
        push @{$EXPORT_TAGS{all}},    $subClassConstructor;
        push @{$EXPORT_TAGS{values}}, $subClassConstructor;

        eval "use $subClass;";
        die "$@" if $@;

        no strict 'refs';
        *$subClassConstructor = sub {
            $subClass->new(pop @_);
        };

        *$subAccessor = sub {
            croak "Illegal accessor ($subAccessor) for @{[ ref $_[0] || $_[0] || __PACKAGE__ ]}";
        };
    }


    for my $method (qw(getChild removeChild addChild getKeys asType asPropertyList)) {
        no strict 'refs';
        *$method = sub {
            croak "Illegal accessor ($method) for @{[ ref $_[0] || $_[0] || __PACKAGE__ ]}";
        };
    }

}

sub new {
    my $class = shift;
    my $className = ref ($class) || $class;
    croak "@{[__PACKAGE__]} is an abstract class"
        if $className eq __PACKAGE__;

    my $type;
    if ($className =~ /^@{[__PACKAGE__]}::(\S+)$/) {
        $type = Jboss::DMR::ModelType->ValueOf($1);
        croak "Unknown type($type) for ModelValue"
            unless defined $type;
    } else {
        croak "Unknown type $className";
    }


    my $self = bless { }, $className;
    $self->type($type);
    $self->value(shift);
    $self;
}

sub type {
    my $self = shift;
    my $type = $_[0];
    if (defined $type) {
        $self->{'_type'} = $type;
    }
    $self->{'_type'};
}

sub getType {
    chr($_[0]->type);
}

sub getTypeName {
    Jboss::DMR::ModelType->ValueOf($_[0]->type);
}

sub clone {
    return bless dclone $_[0], ref $_[0] || $_[0]
}

sub struct {
    my $self = shift;
    return $self->value;
}

sub validate {
    1;
}

sub value {
    my $self = shift;
    if (scalar @_) {
        my $value = shift;
        $self->validate($value);
        $self->{'_value'} = $value;
    }
    $self->{'_value'};
}

sub getValue {
    $_[0]->{'_value'};
}

sub _NumericValueOf($) {
    my $value = pop @_;

    my $float_value = new Math::BigInt($value);

    my ($digits, $fraction) = $float_value->length;
    if ($fraction == 0) {
        return IntValue($value)
            if (Jboss::DMR::ModelValue::Int->ValidInt($value));

        return LongValue($value)
            if (Jboss::DMR::ModelValue::Long->ValidLong($value));

        return DoubleValue($value)
            if (Jboss::DMR::ModelValue::Double->ValidDouble($value));

        return BigIntegerValue(new Math::BigInt($value));

    } else {
        return DoubleValue($value)
            if (Jboss::DMR::ModelValue::Double->ValidDouble($value));

        return new BigDecimalValue($float_value);
    }
}

sub NumericValueOf($$) {
    croak "usage:@{[__PACKAGE__]}->NumericValueOf(\\\$value)"
        unless scalar @_ == 2;

    my $value = pop @_;
    looks_like_number $value
        or croak "$value does not appear to be numeric";

    _NumericValueOf "$value";
}

sub _ValueOf;
sub _ValueOf($) {

    my $value = pop @_;
    return UndefinedValue()  unless defined $value;
    return $value if blessed $value && $value->isa('Jboss::DMR::ModelValue');

    if (my $ret = looks_like_number "$value") {
        return _NumericValueOf $value;
    }
    if (ref $value) {

        if (blessed $value) {
            return BooleanValue($value) if $value->isa('Jboss::DMR::ModelType::Boolean');
            return ObjectValue($value);
        }
        
        return ListValue($value)     if ref $value eq 'ARRAY';
        return ObjectValue($value)   if ref $value eq 'HASH';
        return BytesValue($value)    if ref $value eq 'SCALAR';
        return ValueOf(&$value)      if ref $value eq 'CODE';
        croak "Unknown value type @{[ ref $value ]}";
    }

    return StringValue($value);
}

sub ValueOf($$) {
    croak "usage:@{[__PACKAGE__]}->ValueOf(\\\$value)"
        unless scalar @_ == 2;
    _ValueOf pop @_;
}

1;
