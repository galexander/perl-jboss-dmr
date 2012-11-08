package Jboss::DMR::ModelType;
use strict;
use warnings;
use Exporter qw(import);

use constant BIG_DECIMAL => ord('d');
use constant BIG_INTEGER => ord('i');
use constant BOOLEAN     => ord('Z');
use constant BYTES       => ord('b');
use constant DOUBLE      => ord('D');
use constant EXPRESSION  => ord('e');
use constant INT         => ord('I');
use constant LIST        => ord('l');
use constant LONG        => ord('J');
use constant OBJECT      => ord('o');
use constant PROPERTY    => ord('p');
use constant STRING      => ord('s');
use constant UNDEFINED   => ord('u');

use constant BIG_DECIMAL_NAME => 'BigDecimal';
use constant BIG_INTEGER_NAME => 'BigInteger';
use constant BOOLEAN_NAME     => 'Boolean';
use constant BYTES_NAME       => 'Bytes';
use constant DOUBLE_NAME      => 'Double';
use constant EXPRESSION_NAME  => 'Expression';
use constant INT_NAME         => 'Int';
use constant LIST_NAME        => 'List';
use constant LONG_NAME        => 'Long';
use constant OBJECT_NAME      => 'Object';
use constant PROPERTY_NAME    => 'Property';
use constant STRING_NAME      => 'String';
use constant UNDEFINED_NAME   => 'Undefined';

our %ModelTypes = (
    'BIG_DECIMAL'   => BIG_DECIMAL,
    'BIG_INTEGER'   => BIG_INTEGER,
    'BOOLEAN'       => BOOLEAN,
    'BYTES'         => BYTES,
    'DOUBLE'        => DOUBLE,
    'EXPRESSION'    => EXPRESSION,
    'INT'           => INT,
    'LIST'          => LIST,
    'LONG'          => LONG,
    'OBJECT'        => OBJECT,
    'PROPERTY'      => PROPERTY,
    'STRING'        => STRING,
    'UNDEFINED'     => UNDEFINED
);

our %TypeMap = (
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

our %TypeMapNames = reverse %TypeMap;

our @TYPE_NAMES = sort keys %TypeMap;


our  @EXPORT_OK   = (keys %ModelTypes, qw(@TYPE_NAMES), qw(true false));
our  %EXPORT_TAGS = (qw(types)     => [ keys %ModelTypes ],
                    qw(typenames) => [ qw(@TYPE_NAMES) ],
                    qw(bool)     => [ qw (true false) ]);

use constant true  => do { bless \(my $dummy = 1), "Jboss::DMR::ModelType::Boolean" };
use constant false => do { bless \(my $dummy = 0), "Jboss::DMR::ModelType::Boolean" };

sub ValueOf {
    my $type = pop;
    return $TypeMap{$type};
}


1;
