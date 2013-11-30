
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "Module::Build" => "0.4203"
  },
  "configure_requires" => {
    "Module::Build" => "0.4203"
  },
  "dist_abstract" => "BeLike::KENTNL when you build your distributions.",
  "dist_author" => [
    "Kent Fredric <kentnl\@cpan.org>"
  ],
  "dist_name" => "Dist-Zilla-PluginBundle-Author-KENTNL",
  "dist_version" => "2.005001",
  "license" => "perl",
  "module_name" => "Dist::Zilla::PluginBundle::Author::KENTNL",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Dist::Zilla" => "5.006",
    "Dist::Zilla::File::FromCode" => "5.006",
    "Dist::Zilla::Plugin::Authority" => "1.006",
    "Dist::Zilla::Plugin::AutoPrereqs" => "5.006",
    "Dist::Zilla::Plugin::Bootstrap::lib" => "0.04000002",
    "Dist::Zilla::Plugin::CheckExtraTests" => "0.016",
    "Dist::Zilla::Plugin::ConfirmRelease" => "5.006",
    "Dist::Zilla::Plugin::EOLTests" => "0.02",
    "Dist::Zilla::Plugin::Git::Check" => "2.019",
    "Dist::Zilla::Plugin::Git::Commit" => "2.019",
    "Dist::Zilla::Plugin::Git::CommitBuild" => "2.019",
    "Dist::Zilla::Plugin::Git::GatherDir" => "2.019",
    "Dist::Zilla::Plugin::Git::NextVersion" => "2.019",
    "Dist::Zilla::Plugin::Git::Tag" => "2.019",
    "Dist::Zilla::Plugin::GithubMeta" => "0.42",
    "Dist::Zilla::Plugin::License" => "5.006",
    "Dist::Zilla::Plugin::Manifest" => "5.006",
    "Dist::Zilla::Plugin::ManifestSkip" => "5.006",
    "Dist::Zilla::Plugin::MetaConfig" => "5.006",
    "Dist::Zilla::Plugin::MetaData::BuiltWith" => "0.04000002",
    "Dist::Zilla::Plugin::MetaJSON" => "5.006",
    "Dist::Zilla::Plugin::MetaProvides::Package" => "1.15000001",
    "Dist::Zilla::Plugin::MetaTests" => "5.006",
    "Dist::Zilla::Plugin::MetaYAML" => "5.006",
    "Dist::Zilla::Plugin::MinimumPerl" => "1.003",
    "Dist::Zilla::Plugin::ModuleBuild" => "5.006",
    "Dist::Zilla::Plugin::NextRelease" => "5.006",
    "Dist::Zilla::Plugin::PerlTidy" => "0.13",
    "Dist::Zilla::Plugin::PkgVersion" => "5.006",
    "Dist::Zilla::Plugin::PodCoverageTests" => "5.006",
    "Dist::Zilla::Plugin::PodSyntaxTests" => "5.006",
    "Dist::Zilla::Plugin::PodWeaver" => "4.002",
    "Dist::Zilla::Plugin::Prereqs" => "5.006",
    "Dist::Zilla::Plugin::Prereqs::MatchInstalled" => "v0.1.6",
    "Dist::Zilla::Plugin::ReadmeAnyFromPod" => "0.133290",
    "Dist::Zilla::Plugin::ReadmeFromPod" => "0.21",
    "Dist::Zilla::Plugin::ReportVersions::Tiny" => "1.10",
    "Dist::Zilla::Plugin::Test::CPAN::Changes" => "0.008",
    "Dist::Zilla::Plugin::Test::Compile::PerFile" => "0.001001",
    "Dist::Zilla::Plugin::Test::Kwalitee" => "2.07",
    "Dist::Zilla::Plugin::Test::MinimumVersion" => "2.000005",
    "Dist::Zilla::Plugin::Test::Perl::Critic" => "2.112410",
    "Dist::Zilla::Plugin::TestRelease" => "5.006",
    "Dist::Zilla::Plugin::Twitter" => "0.024",
    "Dist::Zilla::Plugin::UploadToCPAN" => "5.006",
    "Dist::Zilla::Role::BundleDeps" => "0.001001",
    "Dist::Zilla::Role::FileGatherer" => "5.006",
    "Dist::Zilla::Role::MintingProfile::ShareDir" => "5.006",
    "Dist::Zilla::Role::PluginBundle" => "5.006",
    "Dist::Zilla::Util::EmulatePhase" => "0.01025803",
    "IO::Socket::SSL" => "1.962",
    "LWP::Protocol::https" => "6.04",
    "Moose" => "2.1005",
    "MooseX::AttributeShortcuts" => "0.022",
    "MooseX::Has::Sugar" => "0.05070422",
    "MooseX::Types" => "0.38",
    "Net::SSLeay" => "1.55",
    "Perl::PrereqScanner" => "1.018",
    "Pod::Coverage::TrustPod" => "0.100003",
    "String::Formatter" => "0.102084",
    "Test::CPAN::Meta" => "0.23",
    "Test::EOL" => "1.5",
    "Test::Perl::Critic" => "1.02",
    "Test::Pod" => "1.48",
    "Test::Pod::Coverage" => "1.08",
    "namespace::autoclean" => "0.14",
    "perl" => "5.006",
    "strict" => 0,
    "version" => "0.9904",
    "warnings" => 0
  },
  "script_files" => [],
  "share_dir" => {
    "module" => {
      "Dist::Zilla::MintingProfile::Author::KENTNL" => "share/profiles"
    }
  },
  "test_requires" => {
    "Capture::Tiny" => "0.23",
    "File::pushd" => "1.005",
    "FindBin" => 0,
    "Git::Wrapper" => "0.030",
    "JSON" => "2.90",
    "Module::Metadata" => "1.000019",
    "Path::Class::Dir" => "0.32",
    "Path::Tiny" => "0.047",
    "Test::DZil" => "5.006",
    "Test::Fatal" => "0.013",
    "Test::File::ShareDir" => "v0.4.1",
    "Test::More" => "1.001002",
    "Test::Output" => "1.02",
    "lib" => 0
  }
);


my %fallback_build_requires = (
  "Capture::Tiny" => "0.23",
  "File::pushd" => "1.005",
  "FindBin" => 0,
  "Git::Wrapper" => "0.030",
  "JSON" => "2.90",
  "Module::Build" => "0.4203",
  "Module::Metadata" => "1.000019",
  "Path::Class::Dir" => "0.32",
  "Path::Tiny" => "0.047",
  "Test::DZil" => "5.006",
  "Test::Fatal" => "0.013",
  "Test::File::ShareDir" => "v0.4.1",
  "Test::More" => "1.001002",
  "Test::Output" => "1.02",
  "lib" => 0
);


unless ( eval { Module::Build->VERSION(0.4004) } ) {
  delete $module_build_args{test_requires};
  $module_build_args{build_requires} = \%fallback_build_requires;
}

my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
