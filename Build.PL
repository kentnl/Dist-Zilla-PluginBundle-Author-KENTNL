
use strict;
use warnings;

use Module::Build 0.3601;

my %module_build_args = (
  'build_requires' => {
    'File::Find' => '0',
    'Module::Build' => '0.3601',
    'Test::Kwalitee' => '0',
    'Test::More' => '0',
    'Test::Perl::Critic' => '0'
  },
  'configure_requires' => {
    'Module::Build' => '0.3601'
  },
  'dist_abstract' => 'BeLike::KENTNL when you build your distributions.',
  'dist_author' => [
    'Kent Fredric <kentnl@cpan.org>'
  ],
  'dist_name' => 'Dist-Zilla-PluginBundle-KENTNL',
  'dist_version' => '0.01001713',
  'license' => 'perl',
  'module_name' => 'Dist::Zilla::PluginBundle::KENTNL',
  'recommends' => {},
  'requires' => {
    'Carp' => '0',
    'Dist::Zilla' => '2.101310',
    'Dist::Zilla::Plugin::AutoVersion::Relative' => '0.01006104',
    'Dist::Zilla::Plugin::CompileTests' => '1.092870',
    'Dist::Zilla::Plugin::Git' => '1.093410',
    'Dist::Zilla::Plugin::MetaProvides' => '1.10027518',
    'Dist::Zilla::Plugin::PodWeaver' => '3.093321',
    'Dist::Zilla::Plugin::ReadmeFromPod' => '0.04',
    'Dist::Zilla::Plugin::Repository' => '0.11',
    'Dist::Zilla::Plugin::Twitter' => '0.007',
    'Dist::Zilla::Role::PluginBundle' => '0',
    'Moose' => '1.01',
    'Moose::Autobox' => '0',
    'MooseX::Has::Sugar' => '0.0405',
    'MooseX::Types' => '0.21',
    'namespace::autoclean' => '0.09'
  },
  'script_files' => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
