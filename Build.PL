
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  'build_requires' => {
    'Module::Build' => '0.3601'
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
  'requires' => {},
  'script_files' => [],
  'share_dir' => {
    'module' => {
      'Dist::Zilla::MintingProfile::Author::KENTNL' => 'share/profiles'
    }
  }
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
