#!/usr/bin/perl -w 

use strict;
use warnings;
use Test::More qw(no_plan);


use lib 'lib';
use_ok 'Jboss::DMR::ModelNode';

can_ok 'Jboss::DMR::ModelNode', 'new';
can_ok 'Jboss::DMR::ModelNode', 'id';
can_ok 'Jboss::DMR::ModelNode', 'get';
can_ok 'Jboss::DMR::ModelNode', 'set';
can_ok 'Jboss::DMR::ModelNode', 'add';
can_ok 'Jboss::DMR::ModelNode', 'struct';
can_ok 'Jboss::DMR::ModelNode', 'encoded';

use Data::Dumper;
my $op = Jboss::DMR::ModelNode->new();
$op->get("operation")->set("read-attribute");
my $address = $op->get("address");
$address->add("subsystem", "datasources");
$address->add("data-source", "datasourceName");
$op->get("jndi-name")->set("java:jboss/datasources/datasourceName");
$op->get("driver-name")->set("h2");
$op->get("enabled")->set("true");
$op->get("pool-name")->set("MigrateDS");
$op->get("connection-url")->set("jdbc:h2:mem:test;DB_CLOSE_DELAY=-1");
