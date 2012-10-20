package CatalystX::Example::IOC::Blog::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
__PACKAGE__->config(namespace => '');

sub index :Path :Args(0) {
    my ( $self, $ctx ) = @_;

    $self->_render_page($ctx, 'index.tx');
}

sub default :Path {
    my ( $self, $ctx ) = @_;

    # the filename of the post or the page is the path
    # concatenated with the suffix: .tx
    my $filename = $ctx->req->path . '.tx';
    # it really shouldn't be hardcoded, but we'll leave it for a next version

    $self->_render_page($ctx, $filename);
}

sub _render_page {
    my ( $self, $ctx, $filename ) = @_;
    # first we check wether the static file already exists
    # if it does, just show it
    if ( $ctx->view('Static')->exists( $filename ) ) {
        $ctx->detach("View::Static");
    }

    # otherwise, we try and render it from the templates
    my $result = $ctx->container->resolve(
        service    => '/model/RenderToStatic',
        parameters => { filename => $filename },
    );

    # if we succeeded, i.e., we found the template to be rendered, we can call
    # View::Static to process the newly compiled static page
    if ($result) {
        $ctx->detach("View::Static");
    }

    # if all failed, we don't have the page
    $ctx->response->body( 'Page not found' );
    $ctx->response->status(404);
}

sub end : ActionClass('RenderView') {}

__PACKAGE__->meta->make_immutable;

1;

=head1 NAME

CatalystX::Example::IOC::Blog::Controller::Root - Root Controller for CatalystX::Example::IOC::Blog

=head1 DESCRIPTION

The main controller.

=head1 METHODS

=head2 index

The root page (/)

=head2 default

Standard 404 error page

=head2 end

Attempt to render a view, if needed.

=head1 AUTHOR

André Walker

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
