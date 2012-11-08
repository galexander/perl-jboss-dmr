package Jboss::DMR::Property;
use strict;
use warnings;
use Carp qw(croak);
use Storable qw(dclone);
use Scalar::Util qw(blessed);

use Jboss::DMR::ModelNode;

sub new {
    my $class = shift;
    my $self  = bless {}, ref $class || $class || __PACKAGE__;
    croak "usage: @{[__PACKAGE__]}->new(name => value, [ copy ])"
        unless scalar @_ == 2 || scalar @_ == 3;

    my $name  = shift;
    my $value = shift;
    my $copy  = shift if scalar @_;

    if (defined $value) {
            if (blessed $value) {
                croak 'Invalid arg $value is not a Jboss::DMR::ModelNode'
                    unless $value->isa('Jboss::DMR::ModelNode');
            } else {
                $value = Jboss::DMR::ModelNode->new($value);
            }

    } else {
        $value = Jboss::DMR::ModelValue::Undefined();
    }
    
    defined $name
        or croak "@{[__PACKAGE__]}->new() 'name' not defined";

    $self->{'_name' }  = $name;
    $self->{'_value'}
        = defined $copy && $copy
            ? $value->clone
            : $value;

    $self;
}

sub getName {
    my $self = shift;
    $self->{'_name'};
}

sub getValue {
    my $self = shift;
    $self->{'_value'};
}

sub clone {
    return bless dclone $_[0], ref $_[0] || $_[0];
}

1;
