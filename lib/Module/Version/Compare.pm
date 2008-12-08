package Module::Version::Compare;

use base qw( Class::Accessor::Fast );
use strict;
use warnings;
use File::Spec;

use 5.8.1;

our $VERSION = '0.00001_00';

__PACKAGE__->mk_accessors qw( hosts module );

sub new {
    my $class = shift;
    my $conf  = shift;

    return $class->SUPER::new(
        { hosts => $conf->{hosts}, module => $conf->{module} } );
}

sub do_compare {
    my $self = shift;

    ## hosts list
    my $hosts_list = $self->{hosts};

    ## module_lists
    my $module_list = $self->{module};

    my $all_result = {};
    foreach my $host_name (@$hosts_list) {
        my $result = $self->_analyze_by_host( $host_name, $module_list );
        $all_result->{$host_name} = $result;
    }
    return ($all_result);
}

sub _analyze_by_host {
    my $self        = shift;
    my $host_name   = shift;
    my $module_list = shift;

    my $version_result = {};

    foreach (@$module_list) {
        my $version = $self->_check_module_version( $host_name, $_ );

        ## module_name ==> module_version
        $version_result->{$_} = $version;
    }
    return ($version_result);
}

sub _check_module_version {
    my $self      = shift;
    my $host_name = shift;
    my $module    = shift;

    my $ssh_string = $self->_make_ssh_string($host_name, $module);

    ## STDERR is not display.
    open( STDERR, '> ' . File::Spec->devnull() );

    open( CMD,    "$ssh_string  |" );
    my $ver = <CMD>;
    close(CMD);
    chomp($ver);
    $ver = 'not_install' if ( !$ver );
    return $ver;
}

sub _make_ssh_string {
    my $self      = shift;
    my $host_name = shift;
    my $module    = shift;

    my $module_str = 'ssh -A ';
    $module_str .= $host_name;
    $module_str .= ' perl -e ';
    $module_str .= '\\\'use ' . $module . '\;';
    $module_str .= ' print ' . $module . '\-\>VERSION\\\'';

    return $module_str;
}

1;

__END__

=head1 NAME

Module::Version::Compare - acquired the version of installed perl Module by more than one host.

=head1 SYNOPSIS

  use Module::Version::Compare;
  my $ver    = Module::Version::Compare->new($config);
  my $result = $ver->do_compare();

=head1 DESCRIPTION

Module::Version::Compare is acquire module the version of installed perl Module by more than one host.

This module is available in the server time connected in OpenSSH.

=head1 METHODS

=head2 new()

=head2 do_compare()

=head1 AUTHOR

Kazuhiko Yamakura E<lt>yamakura@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
