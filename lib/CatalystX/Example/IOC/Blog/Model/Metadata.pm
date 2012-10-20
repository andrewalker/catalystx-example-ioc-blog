package CatalystX::Example::IOC::Blog::Model::Metadata;
use Moose;
use namespace::autoclean;
use Text::Xslate;
use Carp qw/croak/;
use Storable qw/store retrieve/;

extends 'Catalyst::Model';

has all_file_names => (
    is => 'ro',
    isa => 'ArrayRef[Str]',
);

has metadata_file => (
    is  => 'ro',
    isa => 'Str',
);

has metadata => (
    is => 'ro',
    lazy => 1,
    builder => '_build_metadata',
);

has view_render => ( is => 'ro' );

has slurper => ( is => 'ro' );

sub _get_metadata_from_file {
    my ($self, $file) = @_;

    # we don't depend on it because it has a parameter
    my $content = $self->slurper->inflate( filename => $file );

    # XXX: not thread safe
    $self->view_render->render($content);
    my $vars = Text::Xslate->current_vars;

    return {
        categories => $vars->{categories}
    };
}

sub save_metadata {
    my ($self) = @_;

    my %categories;

    for my $file (@{ $self->all_file_names }) {
        my $metadata = $self->_get_metadata_from_file( $file );
        for my $cat (@{ $metadata->{categories} }) {
            if (exists $categories{$cat}) {
                push @{ $categories{$cat} }, $file;
            }
            else {
                $categories{$cat} = [ $file ];
            }
        }
    }

    my %metadata = (
        categories => \%categories,
    );

    store(\%metadata, $self->metadata_file);
}

sub _build_metadata {
    my ($self) = @_;

    if (! -e $self->metadata_file) {
        $self->save_metadata;
    }

    return retrieve($self->metadata_file);
}

sub list_categories {
    my ($self) = @_;

    my $categories = $self->metadata->{categories};

    return [ keys %{ $categories } ];
}

sub list_posts_in_category {
    my ($self, $category) = @_;

    my $categories = $self->metadata->{categories};

    croak "Category $category not found."
        if not exists $categories->{$category};

    return $categories->{$category};
}

# TODO: tags, timestamp, author(s), etc

__PACKAGE__->meta->make_immutable;

1;

=head1 NAME

CatalystX::Example::IOC::Blog::Model::Metadata - Catalyst Model

=head1 DESCRIPTION

Catalyst Model.

=head1 AUTHOR

André Walker

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
