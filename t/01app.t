#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use Catalyst::Test 'CatalystX::Example::IOC::Blog';

ok( request('/')->is_success, 'Request should succeed' );

done_testing();
