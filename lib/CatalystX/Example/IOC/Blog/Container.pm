package CatalystX::Example::IOC::Blog::Container;
use Moose;
use namespace::autoclean;
use Catalyst::IOC;
use CatalystX::IOC::CustomBlockInjection;
use Bread::Board::BlockInjection;

extends 'Catalyst::IOC::Container';

sub BUILD {
    my $self = shift;

    $self->get_sub_container('view')->add_service(
        Catalyst::IOC::ConstructorInjection->new(
            name                    => 'Static',
            lifecycle               => 'Singleton',
            class                   => 'CatalystX::Example::IOC::Blog::View::Static',
            catalyst_component_name => 'CatalystX::Example::IOC::Blog::View::Static',
            dependencies            => [ depends_on( '/catalyst_application' ), depends_on( '/path_to_static' ) ],
        )
    );

    $self->add_service(
        Bread::Board::BlockInjection->new(
            name => 'path_to_posts',
            dependencies => [ depends_on('/config') ],
            lifecycle => 'Singleton',
            block => sub {
                my $s = shift;
                my $config = $s->param('config');

                if (! $config->{path_to_posts}) {
                    # there's really no point having this app without path_to_posts
                    die "path_to_posts needs to be defined in the config";
                }

                return $config->{path_to_posts};
            },
        )
    );

    $self->add_service(
        Bread::Board::BlockInjection->new(
            name => 'path_to_static',
            dependencies => [ depends_on('/config') ],
            lifecycle => 'Singleton',
            block => sub {
                my $s = shift;
                my $config = $s->param('config');
                $config->{path_to_static} ||= $config->{home} . '/tmp/static';

                if (! -d $config->{path_to_static}) {
                    mkdir $config->{path_to_static};
                }

                return $config->{path_to_static};
            },
        )
    );

    $self->add_service(
        Bread::Board::BlockInjection->new(
            name         => 'metadata_file',
            dependencies => [ depends_on('/config') ],
            lifecycle    => 'Singleton',
            block        => sub {
                my $s      = shift;
                my $config = $s->param('config');
                $config->{metadata_file} ||= $config->{home} . '/tmp/metadata';

                return $config->{metadata_file};
            },
        )
    );

    $self->add_service(
        Bread::Board::BlockInjection->new(
            name => 'all_post_and_page_names',
            dependencies => {
                path => depends_on('/path_to_posts'),
            },
            # NOTE: no lifecycle. It should be rebuilt at every call
            block => sub {
                my $s = shift;
                my $path = $s->param('path');

                opendir(my $dir, $path);
                my @files = <$dir>;
                closedir($dir);

                return [ grep { $_ !~ m[^\.{1,2}$] } @files ];
            },
        )
    );

    $self->get_sub_container('view')->add_service(
        Catalyst::IOC::ConstructorInjection->new(
            name                    => 'Render',
            lifecycle               => 'Singleton',
            class                   => 'CatalystX::Example::IOC::Blog::View::Render',
            catalyst_component_name => 'CatalystX::Example::IOC::Blog::View::Render',
            dependencies            => {
                catalyst_application => depends_on( '/catalyst_application' ),
            },
        )
    );

    $self->get_sub_container('view')->add_service(
        CatalystX::IOC::CustomBlockInjection->new(
            name                    => 'Slurper',
            catalyst_component_name => 'CatalystX::Example::IOC::Blog::View::Slurper',
            dependencies            => {
                catalyst_application => depends_on( '/catalyst_application' ),
                path_to_posts        => depends_on( '/path_to_posts' ),
            },
            parameters              => { filename => { isa => 'Str' } },
            block                   => sub {
                my $s = shift;
                my $filename = $s->param('path_to_posts') . '/' . $s->param('filename');

                local $/;

                open my $fh, '<', $filename;
                my $content = <$fh>;
                close $fh;

                return $content;
            },
        )
    );

    $self->get_sub_container('model')->add_service(
        CatalystX::IOC::CustomBlockInjection->new(
            name                    => 'RenderToStatic',
            catalyst_component_name => 'CatalystX::Example::IOC::Blog::Model::RenderToStatic',
            dependencies            => {
                catalyst_application => depends_on( '/catalyst_application' ),
                render               => depends_on( '/view/Render' ),
                slurp                => depends_on( '/view/Slurper' ),
                path_to_posts        => depends_on( '/path_to_posts' ),
            },
            parameters              => { filename => { isa => 'Str' } },
            block                   => sub {
                my $s        = shift;
                my $slurp    = $s->param('slurp');
                my $filename = $s->param('path_to_posts') . '/' . $s->param('filename');

                my $str      = $slurp->inflate( filename => $filename );
                my $content  = $s->param('render')->render( \$str, {} );

                open my $fh, '>', $filename;
                print $fh $content;
                close $fh;
            },
        )
    );

    $self->get_sub_container('model')->add_service(
        Catalyst::IOC::ConstructorInjection->new(
            name         => 'Metadata',
            class        => 'CatalystX::Example::IOC::Blog::Model::Metadata',
            catalyst_component_name => 'CatalystX::Example::IOC::Blog::Model::Metadata',
            dependencies => {
                catalyst_application => depends_on( '/catalyst_application' ),
                view_render          => depends_on( '/view/Render' ),
                all_file_names       => depends_on( '/all_post_and_page_names' ),
                metadata_file        => depends_on( '/metadata_file' ),
                slurper              => depends_on( '/view/Slurper' ),
            },
        )
    );
}

__PACKAGE__->meta->make_immutable;

1;
