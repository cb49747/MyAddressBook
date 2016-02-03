package AddressBook::View::HTML;

use strict;
use base 'Catalyst::View::TT';

__PACKAGE__->config({
    INCLUDE_PATH => [
        AddressBook->path_to( 'root', 'src' ),
        AddressBook->path_to( 'root', 'lib' )
    ],
    PRE_PROCESS  		=> 'config/main',
    WRAPPER     		=> 'site/wrapper',
    ERROR        		=> 'error.tt2',
    TEMPLATE_EXTENSION	=> '.TT2',
    TIMER        		=> 0,
    render_die   		=> 1,
});

=head1 NAME

AddressBook::View::HTML - Catalyst TTSite View

=head1 SYNOPSIS

See L<AddressBook>

=head1 DESCRIPTION

Catalyst TTSite View.

=head1 AUTHOR

System Administrator

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

