
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "Capture::Tiny" => 0,
    "File::Find" => 0,
    "File::Temp" => 0,
    "File::pushd" => 0,
    "FindBin" => 0,
    "Git::Wrapper" => 0,
    "JSON" => 0,
    "Module::Build" => "0.3601",
    "Path::Class" => 0,
    "Test::DZil" => 0,
    "Test::Fatal" => 0,
    "Test::File::ShareDir" => "v0.3.0",
    "Test::More" => "0.88",
    "Test::Output" => 0
  },
  "configure_requires" => {
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "BeLike::KENTNL when you build your distributions.",
  "dist_author" => [
    "Kent Fredric <kentnl\@cpan.org>"
  ],
  "dist_name" => "Dist-Zilla-PluginBundle-Author-KENTNL",
  "dist_version" => "1.4.0",
  "license" => "perl",
  "module_name" => "Dist::Zilla::PluginBundle::Author::KENTNL",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Carp" => 0,
    "Class::Load" => 0,
    "Dist::Zilla" => "4.300000",
    "Dist::Zilla::File::FromCode" => 0,
    "Dist::Zilla::Plugin::Authority" => 0,
    "Dist::Zilla::Plugin::AutoPrereqs" => "4.200011",
    "Dist::Zilla::Plugin::CheckExtraTests" => 0,
    "Dist::Zilla::Plugin::ConfirmRelease" => 0,
    "Dist::Zilla::Plugin::EOLTests" => "0.02",
    "Dist::Zilla::Plugin::FakeRelease" => 0,
    "Dist::Zilla::Plugin::GatherDir" => 0,
    "Dist::Zilla::Plugin::Git::Check" => "1.102040",
    "Dist::Zilla::Plugin::Git::CommitBuild" => "1.102040",
    "Dist::Zilla::Plugin::Git::NextVersion" => "1.102810",
    "Dist::Zilla::Plugin::Git::Tag" => "1.102040",
    "Dist::Zilla::Plugin::GithubMeta" => "0.08",
    "Dist::Zilla::Plugin::License" => 0,
    "Dist::Zilla::Plugin::Manifest" => 0,
    "Dist::Zilla::Plugin::ManifestSkip" => 0,
    "Dist::Zilla::Plugin::MetaConfig" => 0,
    "Dist::Zilla::Plugin::MetaData::BuiltWith" => "0.03000000",
    "Dist::Zilla::Plugin::MetaJSON" => 0,
    "Dist::Zilla::Plugin::MetaProvides" => "1.14000000",
    "Dist::Zilla::Plugin::MetaProvides::Package" => "1.14000001",
    "Dist::Zilla::Plugin::MetaTests" => 0,
    "Dist::Zilla::Plugin::MetaYAML" => 0,
    "Dist::Zilla::Plugin::MinimumPerl" => 0,
    "Dist::Zilla::Plugin::ModuleBuild" => 0,
    "Dist::Zilla::Plugin::PkgVersion" => 0,
    "Dist::Zilla::Plugin::PodCoverageTests" => 0,
    "Dist::Zilla::Plugin::PodSyntaxTests" => 0,
    "Dist::Zilla::Plugin::PodWeaver" => "3.093321",
    "Dist::Zilla::Plugin::Prereqs" => 0,
    "Dist::Zilla::Plugin::PruneCruft" => 0,
    "Dist::Zilla::Plugin::ReadmeFromPod" => "0.12",
    "Dist::Zilla::Plugin::ReportVersions::Tiny" => "1.01",
    "Dist::Zilla::Plugin::Test::CPAN::Changes" => 0,
    "Dist::Zilla::Plugin::Test::Compile" => "1.112400",
    "Dist::Zilla::Plugin::Test::Kwalitee" => "1.112410",
    "Dist::Zilla::Plugin::Test::MinimumVersion" => 0,
    "Dist::Zilla::Plugin::Test::Perl::Critic" => "1.102280",
    "Dist::Zilla::Plugin::TestRelease" => 0,
    "Dist::Zilla::Plugin::Twitter" => "0.011",
    "Dist::Zilla::Plugin::UploadToCPAN" => 0,
    "Dist::Zilla::Role::FileGatherer" => 0,
    "Dist::Zilla::Role::MintingProfile::ShareDir" => 0,
    "Dist::Zilla::Role::PluginBundle" => 0,
    "IO::Socket::SSL" => 0,
    "LWP::Protocol::https" => "6.00",
    "Moose" => "1.01",
    "Moose::Autobox" => 0,
    "MooseX::Has::Sugar" => "0.05044",
    "MooseX::Types" => "0.21",
    "Net::SSLeay" => "1.36",
    "Perl::PrereqScanner" => "1.006",
    "Pod::Coverage::TrustPod" => 0,
    "Pod::Weaver::Plugin::Encoding" => 0,
    "String::Formatter" => 0,
    "Test::CPAN::Meta" => 0,
    "Test::EOL" => "0.9",
    "Test::Perl::Critic" => 0,
    "namespace::autoclean" => "0.09",
    "perl" => "v5.10.0",
    "strict" => 0,
    "version" => 0,
    "warnings" => 0
  },
  "script_files" => [],
  "share_dir" => {
    "module" => {
      "Dist::Zilla::MintingProfile::Author::KENTNL" => "share/profiles"
    }
  }
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
