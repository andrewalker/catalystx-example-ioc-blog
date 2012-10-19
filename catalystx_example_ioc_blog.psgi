use strict;
use warnings;

use CatalystX::Example::IOC::Blog;

my $app = CatalystX::Example::IOC::Blog->apply_default_middlewares(CatalystX::Example::IOC::Blog->psgi_app);
$app;

