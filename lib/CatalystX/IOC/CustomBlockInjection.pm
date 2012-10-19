package CatalystX::IOC::CustomBlockInjection;
use Moose;
use namespace::autoclean;

extends 'Bread::Board::BlockInjection';
with 'Bread::Board::Service::WithDependencies';

has catalyst_component_name => ( is => 'ro' );

1;
