#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install 1.02;
use Module::Install::Catalyst; # Complain loudly if you don't have
                               # Catalyst::Devel installed or haven't said
                               # 'make dist' to create a standalone tarball.

name 'CatalystX-Example-IOC-Blog';
all_from 'lib/CatalystX/Example/IOC/Blog.pm';

requires 'Catalyst::Runtime' => '5.90016';
requires 'Catalyst::Plugin::Static::Simple';

requires 'Catalyst::View::Xslate';

requires 'Catalyst::Action::RenderView';
requires 'Moose';
requires 'namespace::autoclean';
requires 'Config::General'; # This should reflect the config file format you've chosen

test_requires 'Test::More' => '0.88';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
