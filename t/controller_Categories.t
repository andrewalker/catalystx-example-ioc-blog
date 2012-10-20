use strict;
use warnings;
use Test::More;


use Catalyst::Test 'CatalystX::Example::IOC::Blog';
use CatalystX::Example::IOC::Blog::Controller::Categories;

ok( request('/categories')->is_success, 'Request should succeed' );
done_testing();
