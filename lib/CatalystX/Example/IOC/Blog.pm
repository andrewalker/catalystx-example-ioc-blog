package CatalystX::Example::IOC::Blog;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.90;

# Set flags and add plugins for the application.
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    Static::Simple
/;

extends 'Catalyst';

our $VERSION = '0.01';

# Configure the application.
#
# Note that settings in catalystx_example_ioc_blog.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'CatalystX::Example::IOC::Blog',
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    enable_catalyst_header => 1, # Send X-Catalyst header
);

# Start the application
__PACKAGE__->setup();

if (!__PACKAGE__->can('container')) {
    die "You need to use Catalyst from the gsoc_breadboard branch";
}

1;

__END__

=encoding utf8

=head1 NAME

CatalystX::Example::IOC::Blog - Catalyst based application

=head1 SYNOPSIS

    script/catalystx_example_ioc_blog_server.pl

=head1 DESCRIPTION

See README.pod

=head1 SEE ALSO

L<CatalystX::Example::IOC::Blog::Controller::Root>, L<Catalyst>

=head1 AUTHOR

André Walker

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
