package CatalystX::Example::IOC::Blog::View::Render;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::Xslate';

has theme => (
    is => 'ro',
    isa => 'Str',
);

around path => sub {
    my $orig = shift;
    my $self = shift;

    my $paths = $self->$orig(@_);

    return [ map { $_ . '/' . $self->theme } @$paths ];
};

sub save_metadata {
    my ($self, $ctx, $metadata) = @_;
    my $model = $ctx->stash->{current_model_instance};

    if ($model && ref $model eq 'CatalystX::Example::IOC::Blog::Model::Metadata') {
        $model->current_metadata($metadata);
    }
}

has '+expose_methods' => (
    default => sub {
        [ 'save_metadata' ];
    },
);


1;

=head1 NAME

CatalystX::Example::IOC::Blog::View::Render - Xslate View for CatalystX::Example::IOC::Blog

=head1 DESCRIPTION

Xslate View for CatalystX::Example::IOC::Blog.
