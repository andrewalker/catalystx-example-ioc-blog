package CatalystX::Example::IOC::Blog::View::Static;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View';

has path_to_static_site => (
    is => 'ro',
    isa => 'Str',
);

sub exists {
    my ($self, $file) = @_

    # check if file exists
}

sub render {
    my ($self, $file) = @_;

    # load file
}

sub process {
    my ($self, $c) = @_;

    my $stash = $c->stash;
    my $template = $stash->{template};

    my $output = $self->render($template);

    my $res = $c->response;
    if (! $res->content_type) {
        $res->content_type('text/html; charset=' . $self->content_charset);
    }

    $res->body( $output );

    return 1;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

CatalystX::Example::IOC::Blog::View::Static - Catalyst View

=head1 DESCRIPTION

Catalyst View.

=head1 AUTHOR

André Walker

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
