#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install;
use Module::Install::Catalyst; # Complain loudly if you don't have
                               # Catalyst::Devel installed or haven't said
                               # 'make dist' to create a standalone tarball.

name 'AddressBook';
all_from 'lib/AddressBook.pm';

requires 'Catalyst::Runtime' => '5.90103';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Plugin::Session::Store::DBIC';
requires 'Catalyst::Plugin::Authentication' => '0.10023';
requires 'Catalyst::Plugin::Authorization::Roles' => '0.09';
requires 'Catalyst::Plugin::Authorization::ACL' => '0.16';
requires 'Text::CSV_XS' => '1.2';
requires 'Config::JFDI' => '0.065';
requires 'Moose' => '2.1604';
requires 'namespace::autoclean' => '0.28';
requires 'Config::General' => '2.60';
requires 'FCGI' => '0.77';

test_requires 'Test::More' => '0.88';

catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
