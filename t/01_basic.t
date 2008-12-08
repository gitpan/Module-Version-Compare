use strict;
use warnings;
use Module::Version::Compare;

use Test::More tests => 1;

## get ipaddress myself
my $str          = "ifconfig | grep \'inet addr\'";
my $my_ipaddress = undef;

open( IN, "$str |" );
my $myself = <IN>;
close(IN);

if ( $myself =~ /inet addr:([0-9]+.[0-9]+.[0-9]+.[0-9]+)/ ) {
    $my_ipaddress = $1;
}

my $config = {
    hosts  => [ $my_ipaddress ],
    module => [ 'DAMMY', ]
};

{
    ## Get Perl Module Version Check myself.
    my $ver    = Module::Version::Compare->new($config);
    my $result = $ver->do_compare();
    my $dummy = { $my_ipaddress => { 'DAMMY' => 'not_install' } };
    is_deeply( $result, $dummy, 'module check compare' );
}

