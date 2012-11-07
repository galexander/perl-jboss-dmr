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


our @EXPORT_OK   = (keys %ModelTypes, qw(true false));
our %EXPORT_TAGS = (qw(types) => [ keys %ModelTypes ], qw(bool) => [ qw (true false) ]);

use constant true  => do { bless \(my $dummy = 1), "Jboss::DMR::ModelType::Boolean" };
use constant false => do { bless \(my $dummy = 0), "Jboss::DMR::ModelType::Boolean" };



1;
