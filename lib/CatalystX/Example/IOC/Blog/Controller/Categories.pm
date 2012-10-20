package CatalystX::Example::IOC::Blog::Controller::Categories;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

sub base : Chained('/') PathPrefix CaptureArgs(0) {
    my ( $self, $ctx ) = @_;

    my $metadata = $ctx->model('Metadata');
    $ctx->stash->{current_model_instance} = $metadata;
}

sub list : Chained('base') PathPart Args(0) {
    my ( $self, $ctx ) = @_;

    $ctx->stash(
        categories => $ctx->model->list_categories,
        template   => 'list.tx',
    );

    $ctx->detach('View::Render');
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

CatalystX::Example::IOC::Blog::Controller::Categories - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head2 index

=head1 AUTHOR

André Walker

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
