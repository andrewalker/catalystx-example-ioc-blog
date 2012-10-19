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

    return $self->$orig(@_) . '/' . $self->theme;
};

1;

=head1 NAME

CatalystX::Example::IOC::Blog::View::Render - Xslate View for CatalystX::Example::IOC::Blog

=head1 DESCRIPTION

Xslate View for CatalystX::Example::IOC::Blog.
