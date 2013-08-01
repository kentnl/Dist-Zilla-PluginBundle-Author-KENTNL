
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "Module::Build" => "0.4005"
  },
  "configure_requires" => {
    "Module::Build" => "0.4005"
  },
  "dist_abstract" => "BeLike::KENTNL when you build your distributions.",
  "dist_author" => [
    "Kent Fredric <kentnl\@cpan.org>"
  ],
  "dist_name" => "Dist-Zilla-PluginBundle-Author-KENTNL",
  "dist_version" => "1.7.5",
  "license" => "perl",
  "module_name" => "Dist::Zilla::PluginBundle::Author::KENTNL",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Carp" => 0,
    "Class::Load" => 0,
    "Dist::Zilla" => "4.300029",
    "Dist::Zilla::File::FromCode" => 0,
    "Dist::Zilla::Plugin::Author::KENTNL::Prereqs::Latest::Selective" => "v0.1.0",
    "Dist::Zilla::Plugin::Authority" => "1.006",
    "Dist::Zilla::Plugin::AutoPrereqs" => "4.300029",
    "Dist::Zilla::Plugin::Bootstrap::lib" => "0.02000100",
    "Dist::Zilla::Plugin::CheckExtraTests" => "0.007",
    "Dist::Zilla::Plugin::ConfirmRelease" => "4.300029",
    "Dist::Zilla::Plugin::EOLTests" => "0.02",
    "Dist::Zilla::Plugin::FakeRelease" => "4.300029",
    "Dist::Zilla::Plugin::GatherDir" => "4.300029",
    "Dist::Zilla::Plugin::Git::Check" => "2.009",
    "Dist::Zilla::Plugin::Git::CommitBuild" => "2.009",
    "Dist::Zilla::Plugin::Git::GatherDir" => "2.009",
    "Dist::Zilla::Plugin::Git::NextVersion" => "2.009",
    "Dist::Zilla::Plugin::Git::Tag" => "2.009",
    "Dist::Zilla::Plugin::GithubMeta" => "0.28",
    "Dist::Zilla::Plugin::License" => "4.300029",
    "Dist::Zilla::Plugin::Manifest" => "4.300029",
    "Dist::Zilla::Plugin::ManifestSkip" => "4.300029",
    "Dist::Zilla::Plugin::MetaConfig" => "4.300029",
    "Dist::Zilla::Plugin::MetaData::BuiltWith" => "0.03000100",
    "Dist::Zilla::Plugin::MetaJSON" => "4.300029",
    "Dist::Zilla::Plugin::MetaProvides" => "1.14000001",
    "Dist::Zilla::Plugin::MetaProvides::Package" => "1.14000001",
    "Dist::Zilla::Plugin::MetaTests" => "4.300029",
    "Dist::Zilla::Plugin::MetaYAML" => "4.300029",
    "Dist::Zilla::Plugin::MinimumPerl" => 0,
    "Dist::Zilla::Plugin::ModuleBuild" => "4.300029",
    "Dist::Zilla::Plugin::PerlTidy" => 0,
    "Dist::Zilla::Plugin::PkgVersion" => "4.300029",
    "Dist::Zilla::Plugin::PodCoverageTests" => "4.300029",
    "Dist::Zilla::Plugin::PodSyntaxTests" => "4.300029",
    "Dist::Zilla::Plugin::PodWeaver" => "3.101641",
    "Dist::Zilla::Plugin::Prereqs" => "4.300029",
    "Dist::Zilla::Plugin::PruneCruft" => "4.300029",
    "Dist::Zilla::Plugin::ReadmeAnyFromPod" => "0.120120",
    "Dist::Zilla::Plugin::ReadmeFromPod" => "0.16",
    "Dist::Zilla::Plugin::ReportVersions::Tiny" => "1.08",
    "Dist::Zilla::Plugin::Test::CPAN::Changes" => "0.008",
    "Dist::Zilla::Plugin::Test::Compile" => "1.112820",
    "Dist::Zilla::Plugin::Test::Kwalitee" => "2.03",
    "Dist::Zilla::Plugin::Test::MinimumVersion" => "2.000002",
    "Dist::Zilla::Plugin::Test::Perl::Critic" => "2.112410",
    "Dist::Zilla::Plugin::TestRelease" => "4.300029",
    "Dist::Zilla::Plugin::Twitter" => "0.021",
    "Dist::Zilla::Plugin::UploadToCPAN" => "4.300029",
    "Dist::Zilla::Role::FileGatherer" => 0,
    "Dist::Zilla::Role::MintingProfile::ShareDir" => 0,
    "Dist::Zilla::Role::PluginBundle" => 0,
    "Dist::Zilla::Util::EmulatePhase" => "0.01025802",
    "IO::Socket::SSL" => "1.81",
    "LWP::Protocol::https" => "6.00",
    "Moose" => "1.01",
    "Moose::Autobox" => 0,
    "MooseX::Has::Sugar" => "0.05044",
    "MooseX::Types" => "0.21",
    "Net::SSLeay" => "1.36",
    "Perl::PrereqScanner" => "1.006",
    "Pod::Coverage::TrustPod" => 0,
    "Pod::Weaver::Plugin::Encoding" => "0.01",
    "String::Formatter" => 0,
    "Test::CPAN::Meta" => 0,
    "Test::EOL" => "0.9",
    "Test::Perl::Critic" => 0,
    "Test::Pod" => 0,
    "Test::Pod::Coverage" => 0,
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
  },
  "test_requires" => {
    "Capture::Tiny" => 0,
    "File::Find" => 0,
    "File::Temp" => 0,
    "File::pushd" => 0,
    "FindBin" => 0,
    "Git::Wrapper" => 0,
    "JSON" => 0,
    "Path::Class" => 0,
    "Test::DZil" => 0,
    "Test::Fatal" => 0,
    "Test::File::ShareDir" => "v0.3.0",
    "Test::More" => "0.98",
    "Test::Output" => 0
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
