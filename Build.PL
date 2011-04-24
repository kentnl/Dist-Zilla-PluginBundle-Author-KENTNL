
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  'build_requires' => {
    'English' => '0',
    'File::Find' => '0',
    'File::Temp' => '0',
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
  'dist_name' => 'Dist-Zilla-PluginBundle-Author-KENTNL',
  'dist_version' => '1.0.7',
  'license' => 'perl',
  'module_name' => 'Dist::Zilla::PluginBundle::Author::KENTNL',
  'recommends' => {},
  'recursive_test_files' => 1,
  'requires' => {
    'Carp' => '0',
    'Class::Load' => '0',
    'Dist::Zilla' => '4.101612',
    'Dist::Zilla::File::FromCode' => '0',
    'Dist::Zilla::Plugin::AutoPrereqs' => '0',
    'Dist::Zilla::Plugin::AutoVersion::Relative' => '0.01035617',
    'Dist::Zilla::Plugin::CompileTests' => '1.110930',
    'Dist::Zilla::Plugin::ConfirmRelease' => '0',
    'Dist::Zilla::Plugin::CriticTests' => '1.102280',
    'Dist::Zilla::Plugin::EOLTests' => '0.02',
    'Dist::Zilla::Plugin::ExtraTests' => '0',
    'Dist::Zilla::Plugin::FakeRelease' => '0',
    'Dist::Zilla::Plugin::GatherDir' => '0',
    'Dist::Zilla::Plugin::Git::Check' => '1.102040',
    'Dist::Zilla::Plugin::Git::CommitBuild' => '1.102040',
    'Dist::Zilla::Plugin::Git::NextVersion' => '1.102810',
    'Dist::Zilla::Plugin::Git::Tag' => '1.102040',
    'Dist::Zilla::Plugin::GithubMeta' => '0.08',
    'Dist::Zilla::Plugin::KwaliteeTests' => '1.101420',
    'Dist::Zilla::Plugin::License' => '0',
    'Dist::Zilla::Plugin::Manifest' => '0',
    'Dist::Zilla::Plugin::ManifestSkip' => '0',
    'Dist::Zilla::Plugin::MetaConfig' => '0',
    'Dist::Zilla::Plugin::MetaData::BuiltWith' => '0.01014716',
    'Dist::Zilla::Plugin::MetaJSON' => '0',
    'Dist::Zilla::Plugin::MetaProvides' => '1.12044518',
    'Dist::Zilla::Plugin::MetaProvides::Package' => '1.11044404',
    'Dist::Zilla::Plugin::MetaTests' => '0',
    'Dist::Zilla::Plugin::MetaYAML' => '0',
    'Dist::Zilla::Plugin::ModuleBuild' => '0',
    'Dist::Zilla::Plugin::PkgVersion' => '0',
    'Dist::Zilla::Plugin::PodCoverageTests' => '0',
    'Dist::Zilla::Plugin::PodSyntaxTests' => '0',
    'Dist::Zilla::Plugin::PodWeaver' => '3.093321',
    'Dist::Zilla::Plugin::Prereqs' => '0',
    'Dist::Zilla::Plugin::PruneCruft' => '0',
    'Dist::Zilla::Plugin::ReadmeFromPod' => '0.12',
    'Dist::Zilla::Plugin::ReportVersions::Tiny' => '1.01',
    'Dist::Zilla::Plugin::Test::CPAN::Changes' => '0',
    'Dist::Zilla::Plugin::TestRelease' => '0',
    'Dist::Zilla::Plugin::Twitter' => '0.007',
    'Dist::Zilla::Plugin::UploadToCPAN' => '0',
    'Dist::Zilla::Role::FileGatherer' => '0',
    'Dist::Zilla::Role::MintingProfile::ShareDir' => '0',
    'Dist::Zilla::Role::PluginBundle' => '0',
    'IO::Socket::SSL' => '0',
    'LWP::Protocol::https' => '6.00',
    'Moose' => '1.01',
    'Moose::Autobox' => '0',
    'MooseX::Has::Sugar' => '0.05044',
    'MooseX::Types' => '0.21',
    'Net::SSLeay' => '1.36',
    'Pod::Coverage::TrustPod' => '0',
    'String::Formatter' => '0',
    'Test::CPAN::Meta' => '0',
    'Test::EOL' => '0.9',
    'namespace::autoclean' => '0.09'
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
