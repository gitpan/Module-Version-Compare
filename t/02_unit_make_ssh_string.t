use strict;
use warnings;

use Module::Version::Compare;

use Test::More tests => 1;

{
    my $host_name  = 'test_host';
    my $module     = 'CGI';
    my $ver        = Module::Version::Compare->new;
    my $ssh_string = $ver->_make_ssh_string( $host_name, $module );

    my $dummy =
      "ssh -A test_host perl -e \\\'use CGI\\\; print CGI\\\-\\\>VERSION\\\'";

    is( $ssh_string, $dummy, 'module check compare' );
}

