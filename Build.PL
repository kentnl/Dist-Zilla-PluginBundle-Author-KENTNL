
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  'build_requires' => {
    'File::Find' => '0',
    'File::Spec' => '0',
    'File::Temp' => '0',
    'FindBin' => '0',
    'Module::Build' => '0.3601',
    'Test::More' => '0.88'
  },
  'configure_requires' => {
    'Module::Build' => '0.3601'
  },
  'dist_abstract' => 'BeLike::KENTNL when you build your distributions.',
  'dist_author' => [
    'Kent Fredric <kentnl@cpan.org>'
  ],
  'dist_name' => 'Dist-Zilla-PluginBundle-KENTNL',
  'dist_version' => '0.01007006',
  'license' => 'perl',
  'module_name' => 'Dist::Zilla::PluginBundle::KENTNL',
  'recommends' => {},
  'recursive_test_files' => 1,
  'requires' => {
    'Carp' => '0',
    'Dist::Zilla' => '4.101612',
    'Dist::Zilla::File::FromCode' => '0',
    'Dist::Zilla::Plugin::AutoVersion::Relative' => '0.01006104',
    'Dist::Zilla::Plugin::CompileTests' => '1.101800',
    'Dist::Zilla::Plugin::EOLTests' => '0.02',
    'Dist::Zilla::Plugin::Git' => '1.102040',
    'Dist::Zilla::Plugin::GithubMeta' => '0.08',
    'Dist::Zilla::Plugin::KwaliteeTests' => '1.101420',
    'Dist::Zilla::Plugin::MetaData::BuiltWith' => '0.01000022',
    'Dist::Zilla::Plugin::MetaProvides' => '1.11',
    'Dist::Zilla::Plugin::MetaProvides::Package' => '1.11',
    'Dist::Zilla::Plugin::PodWeaver' => '3.093321',
    'Dist::Zilla::Plugin::PortabilityTests' => '1.101420',
    'Dist::Zilla::Plugin::ReadmeFromPod' => '0.12',
    'Dist::Zilla::Plugin::ReportVersions::Tiny' => '1.01',
    'Dist::Zilla::Plugin::Twitter' => '0.007',
    'Dist::Zilla::Role::FileGatherer' => '0',
    'Dist::Zilla::Role::PluginBundle' => '0',
    'IO::Socket::SSL' => '0',
    'Moose' => '1.01',
    'Moose::Autobox' => '0',
    'MooseX::Has::Sugar' => '0.05',
    'MooseX::Types' => '0.21',
    'Net::SSLeay' => '1.36',
    'Pod::Coverage::TrustPod' => '0',
    'String::Formatter' => '0',
    'Test::CPAN::Meta' => '0',
    'Test::EOL' => '0.8',
    'namespace::autoclean' => '0.09'
  },
  'script_files' => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
