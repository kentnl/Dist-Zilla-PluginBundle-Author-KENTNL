
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  'build_requires' => {
    'Capture::Tiny' => '0',
    'English' => '0',
    'File::Find' => '0',
    'File::Temp' => '0',
    'File::pushd' => '0',
    'FindBin' => '0',
    'Module::Build' => '0.3601',
    'Path::Class' => '0',
    'Test::DZil' => '0',
    'Test::Fatal' => '0',
    'Test::File::ShareDir' => '0.3.0',
    'Test::More' => '0.88',
    'Test::Output' => '0'
  },
  'configure_requires' => {
    'Module::Build' => '0.3601'
  },
  'dist_abstract' => 'BeLike::KENTNL when you build your distributions.',
  'dist_author' => [
    'Kent Fredric <kentnl@cpan.org>'
  ],
  'dist_name' => 'Dist-Zilla-PluginBundle-Author-KENTNL',
  'dist_version' => '1.0.13',
  'license' => 'perl',
  'module_name' => 'Dist::Zilla::PluginBundle::Author::KENTNL',
  'recommends' => {},
  'recursive_test_files' => 1,
  'requires' => {
    'Carp' => '0',
    'Class::Load' => '0',
    'Dist::Zilla::File::FromCode' => '0',
    'Dist::Zilla::Role::FileGatherer' => '0',
    'Dist::Zilla::Role::MintingProfile::ShareDir' => '0',
    'Dist::Zilla::Role::PluginBundle' => '0',
    'Moose' => '0',
    'Moose::Autobox' => '0',
    'String::Formatter' => '0',
    'namespace::autoclean' => '0'
  },
  'script_files' => [],
  'share_dir' => {
    'module' => {
      'Dist::Zilla::MintingProfile::Author::KENTNL' => 'share/profiles'
    }
  }
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
