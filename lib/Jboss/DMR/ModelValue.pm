package Jboss::DMR::ModelValue;
use strict;
use warnings;
use Carp qw(croak);
use Math::BigInt;
use Math::BigFloat;
use Scalar::Util qw(looks_like_number blessed);
use Storable qw(dclone);
use Exporter qw(import);

use Jboss::DMR::ModelType qw(:types);

our %TypeMap;
our %TypeMapNames;
our @EXPORT_OK;
our %EXPORT_TAGS;

BEGIN {

    %TypeMap = (
        BigDecimal  => BIG_DECIMAL,
        BigInteger  => BIG_INTEGER,
        Boolean     => BOOLEAN,
        Bytes       => BYTES,
        Double      => DOUBLE,
        Expression  => EXPRESSION,
        Int         => INT,
        List        => LIST,
        Long        => LONG,
        Object      => OBJECT,
        Property    => PROPERTY,
        String      => STRING,
        Undefined   => UNDEFINED,
    );

    %TypeMapNames = reverse %TypeMap;

    for my $type (keys %TypeMap) {

        my $subClass               = "@{[__PACKAGE__]}\::${type}";
        my $subClassContructor     = "${type}Value";
        my $subStaticContructor    = "${type}";
        my $subAccessor             = "as${type}";

        push @EXPORT_OK,            $subClassContructor;
        push @{$EXPORT_TAGS{all}},  $subClassContructor;

        eval "use $subClass;";
        die "$@" if $@;

        no strict 'refs';
        *$subClassContructor = sub {
            $subClass->new(pop @_);
        };

        *$subAccessor = sub {
            croak "Illegal accessor ($subAccessor) for @{[ ref $_[0] || $_[0] || __PACKAGE__ ]}";
        };
    }

    for my $method (qw(getChild removeChild addChild getKeys asType)) {
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
        $type = $1;
        croak "Unknown $type for ModelValue"
            unless exists $TypeMap{$type};

        $type = $TypeMap{$type};

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
    $TypeMapNames{$_[0]->type};
}

sub clone {
    my $self = shift;
    return bless { %{ dclone $self } }, ref $self || $self;
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
        #no bignum;
        #my $str_value = $value + 0.0;
        #if ($str_value =~ /inf/i || $fraction >= 14) {
        #    return BigDecimalValue(new Math::BigFloat("$value"));
        #} else {
        #    return DoubleValue($value);
        #}
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
    return UndefinedValue() unless defined $value;

    if (my $ret = looks_like_number "$value") {
        return _NumericValueOf $value;
    }
    if (ref $value) {

        if (blessed $value) {
            return BooleanValue($value) if $value->isa('Jboss::DMR::ModelType::Boolean');
            return ObjectValue($value);
        }
        
        return ListValue($value)     if ref $value eq 'ARRAY';
        return PropertyValue($value) if ref $value eq 'HASH';
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
