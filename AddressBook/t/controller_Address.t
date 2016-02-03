use strict;
use warnings;
use Test::More;


use Catalyst::Test 'AddressBook';
use AddressBook::Controller::Address;

ok( request('/address')->is_success, 'Request should succeed' );
done_testing();
