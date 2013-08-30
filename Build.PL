
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "Module::Build" => "0.4007"
  },
  "configure_requires" => {
    "Module::Build" => "0.4007"
  },
  "dist_abstract" => "BeLike::KENTNL when you build your distributions.",
  "dist_author" => [
    "Kent Fredric <kentnl\@cpan.org>"
  ],
  "dist_name" => "Dist-Zilla-PluginBundle-Author-KENTNL",
  "dist_version" => "1.8.2",
  "license" => "perl",
  "module_name" => "Dist::Zilla::PluginBundle::Author::KENTNL",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Carp" => 0,
    "Dist::Zilla" => "4.300037",
    "Dist::Zilla::File::FromCode" => "4.300037",
    "Dist::Zilla::Plugin::Authority" => "1.006",
    "Dist::Zilla::Plugin::AutoPrereqs" => "4.300037",
    "Dist::Zilla::Plugin::Bootstrap::lib" => "0.02000100",
    "Dist::Zilla::Plugin::CheckExtraTests" => "0.011",
    "Dist::Zilla::Plugin::CheckPrereqsIndexed" => "0.009",
    "Dist::Zilla::Plugin::ConfirmRelease" => "4.300037",
    "Dist::Zilla::Plugin::EOLTests" => "0.02",
    "Dist::Zilla::Plugin::FakeRelease" => "4.300037",
    "Dist::Zilla::Plugin::FinderCode" => "4.300037",
    "Dist::Zilla::Plugin::Git::Check" => "2.014",
    "Dist::Zilla::Plugin::Git::Commit" => "2.014",
    "Dist::Zilla::Plugin::Git::CommitBuild" => "2.014",
    "Dist::Zilla::Plugin::Git::GatherDir" => "2.014",
    "Dist::Zilla::Plugin::Git::NextVersion" => "2.014",
    "Dist::Zilla::Plugin::Git::Tag" => "2.014",
    "Dist::Zilla::Plugin::GithubMeta" => "0.32",
    "Dist::Zilla::Plugin::License" => "4.300037",
    "Dist::Zilla::Plugin::Manifest" => "4.300037",
    "Dist::Zilla::Plugin::ManifestSkip" => "4.300037",
    "Dist::Zilla::Plugin::MetaConfig" => "4.300037",
    "Dist::Zilla::Plugin::MetaData::BuiltWith" => "0.03000100",
    "Dist::Zilla::Plugin::MetaJSON" => "4.300037",
    "Dist::Zilla::Plugin::MetaProvides" => "1.14000001",
    "Dist::Zilla::Plugin::MetaProvides::Package" => "1.14000003",
    "Dist::Zilla::Plugin::MetaTests" => "4.300037",
    "Dist::Zilla::Plugin::MetaYAML" => "4.300037",
    "Dist::Zilla::Plugin::MinimumPerl" => "1.003",
    "Dist::Zilla::Plugin::ModuleBuild" => "4.300037",
    "Dist::Zilla::Plugin::ModuleShareDirs" => "4.300037",
    "Dist::Zilla::Plugin::NextRelease" => "4.300037",
    "Dist::Zilla::Plugin::PerlTidy" => "0.13",
    "Dist::Zilla::Plugin::PkgVersion" => "4.300037",
    "Dist::Zilla::Plugin::PodCoverageTests" => "4.300037",
    "Dist::Zilla::Plugin::PodSyntaxTests" => "4.300037",
    "Dist::Zilla::Plugin::PodWeaver" => "3.101642",
    "Dist::Zilla::Plugin::Prereqs" => "4.300037",
    "Dist::Zilla::Plugin::Prereqs::MatchInstalled" => "v0.1.1",
    "Dist::Zilla::Plugin::Prereqs::MatchInstalled::All" => "v0.1.0",
    "Dist::Zilla::Plugin::Prereqs::Plugins" => "v0.1.0",
    "Dist::Zilla::Plugin::PruneCruft" => "4.300037",
    "Dist::Zilla::Plugin::ReadmeAnyFromPod" => "0.131500",
    "Dist::Zilla::Plugin::ReadmeFromPod" => "0.18",
    "Dist::Zilla::Plugin::ReportVersions::Tiny" => "1.09",
    "Dist::Zilla::Plugin::Test::CPAN::Changes" => "0.008",
    "Dist::Zilla::Plugin::Test::Compile" => "2.023",
    "Dist::Zilla::Plugin::Test::Kwalitee" => "2.06",
    "Dist::Zilla::Plugin::Test::MinimumVersion" => "2.000005",
    "Dist::Zilla::Plugin::Test::Perl::Critic" => "2.112410",
    "Dist::Zilla::Plugin::TestRelease" => "4.300037",
    "Dist::Zilla::Plugin::Twitter" => "0.021",
    "Dist::Zilla::Plugin::UploadToCPAN" => "4.300037",
    "Dist::Zilla::Role::FileGatherer" => "4.300037",
    "Dist::Zilla::Role::MintingProfile::ShareDir" => "4.300037",
    "Dist::Zilla::Role::PluginBundle" => "4.300037",
    "Dist::Zilla::Util::EmulatePhase" => "0.01025802",
    "IO::Socket::SSL" => "1.953",
    "LWP::Protocol::https" => "6.04",
    "Moose" => "2.1005",
    "MooseX::Has::Sugar" => "0.05070421",
    "MooseX::Types" => "0.36",
    "Net::SSLeay" => "1.55",
    "Perl::PrereqScanner" => "1.016",
    "Pod::Coverage::TrustPod" => "0.100002",
    "Pod::Weaver::Plugin::Encoding" => "0.01",
    "String::Formatter" => "0.102082",
    "Test::CPAN::Meta" => "0.23",
    "Test::EOL" => "1.5",
    "Test::Perl::Critic" => "1.02",
    "Test::Pod" => "1.48",
    "Test::Pod::Coverage" => "1.08",
    "namespace::autoclean" => "0.13",
    "perl" => "v5.10.0",
    "strict" => 0,
    "version" => "0.9903",
    "warnings" => 0
  },
  "script_files" => [],
  "share_dir" => {
    "module" => {
      "Dist::Zilla::MintingProfile::Author::KENTNL" => "share/profiles"
    }
  },
  "test_requires" => {
    "Capture::Tiny" => "0.22",
    "File::pushd" => "1.005",
    "FindBin" => 0,
    "Git::Wrapper" => "0.030",
    "IO::Handle" => "1.34",
    "IPC::Open3" => "1.13",
    "JSON" => "2.59",
    "Path::Class" => "0.32",
    "Test::DZil" => "4.300037",
    "Test::Fatal" => "0.010",
    "Test::File::ShareDir" => "v0.3.3",
    "Test::More" => "0.98",
    "Test::Output" => "1.02"
  }
);


unless ( eval { Module::Build->VERSION(0.4004) } ) {
  my $tr = delete $module_build_args{test_requires};
  my $br = $module_build_args{build_requires};
  for my $mod ( keys %$tr ) {
    if ( exists $br->{$mod} ) {
      $br->{$mod} = $tr->{$mod} if $tr->{$mod} > $br->{$mod};
    }
    else {
      $br->{$mod} = $tr->{$mod};
    }
  }
}

my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
