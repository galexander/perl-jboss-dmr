package Jboss::DMR;

use strict;
use warnings;

=head1  NAME

    Jboss::DMR

=head1  SYNOPSIS

    use Jboss::DMR::ModelNode qw(:namespace);

    my $request = ModelNode->new();

    $request->get("operation")->set("write-attribute");
    my $address = $request->get("address");
    $address->add("subsystem" => "datasources");
    $address->add("data-source" => "ExampleDS");
    $request->get("name")->set("max-pool-size");
    $request->get("value")->set(10);


    my $json = JSON->new();
    #$json->pretty(1);
    $json->allow_blessed(1);
    $json->convert_blessed(1);
    $json->allow_bignum(1);

    print $json->encode($request), "\n";

=cut



1;
