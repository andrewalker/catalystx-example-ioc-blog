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
            name                    => 'LoadFile',
            catalyst_component_name => 'CatalystX::Example::IOC::Blog::View::LoadFile',
            dependencies            => {
                catalyst_application => depends_on( '/catalyst_application' ),
                config               => depends_on( '/config' ),
            },
            parameters              => { filename => { isa => 'Str' } },
            block                   => sub {
                my $s = shift;
                my $filename = $s->param('config')->{path_to_posts} . '/' . $s->param('filename');

                local $/;

                open my $fh, '<', $filename;
                my $content = <$fh>;
                close $fh;

                return $content;
            },
        )
    );

#   $self->get_sub_container('model')->add_service(
#       Catalyst::IOC::ConstructorInjection->new(
#           name         => 'RequestLifeCycle',
#           lifecycle    => '+Catalyst::IOC::LifeCycle::Request',
#           class        => 'TestAppCustomContainer::Model::RequestLifeCycle',
#           catalyst_component_name => 'TestAppCustomContainer::Model::RequestLifeCycle',
#           dependencies => {
#               catalyst_application => depends_on( '/catalyst_application' ),
#           },
#       )
#   );

#   $self->get_sub_container('model')->add_service(
#       Catalyst::IOC::ConstructorInjection->new(
#           name             => 'DependsOnDefaultSetup',
#           class            => 'TestAppCustomContainer::Model::DependsOnDefaultSetup',
#           catalyst_component_name => 'TestAppCustomContainer::Model::DependsOnDefaultSetup',
#           dependencies     => {
#               catalyst_application => depends_on( '/catalyst_application' ),
#               # FIXME - this is what is blowing up everything:
#               # DefaultSetup needs the context. It's not getting it here!
#               # foo => depends_on('/model/DefaultSetup'),
#               foo => depends_on('/component/model_DefaultSetup'),
#           },
#       )
#   );
}

__PACKAGE__->meta->make_immutable;

1;
