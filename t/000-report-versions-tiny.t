use strict;
use warnings;
use Test::More 0.88;
# This is a relatively nice way to avoid Test::NoWarnings breaking our
# expectations by adding extra tests, without using no_plan.  It also helps
# avoid any other test module that feels introducing random tests, or even
# test plans, is a nice idea.
our $success = 0;
END { $success && done_testing; }

my $v = "\n";

eval {                     # no excuses!
    # report our Perl details
    my $want = '5.10.0';
    my $pv = ($^V || $]);
    $v .= "perl: $pv (wanted $want) on $^O from $^X\n\n";
};
defined($@) and diag("$@");

# Now, our module version dependencies:
sub pmver {
    my ($module, $wanted) = @_;
    $wanted = " (want $wanted)";
    my $pmver;
    eval "require $module;";
    if ($@) {
        if ($@ =~ m/Can't locate .* in \@INC/) {
            $pmver = 'module not found.';
        } else {
            diag("${module}: $@");
            $pmver = 'died during require.';
        }
    } else {
        my $version;
        eval { $version = $module->VERSION; };
        if ($@) {
            diag("${module}: $@");
            $pmver = 'died during VERSION check.';
        } elsif (defined $version) {
            $pmver = "$version";
        } else {
            $pmver = '<undef>';
        }
    }

    # So, we should be good, right?
    return sprintf('%-45s => %-10s%-15s%s', $module, $pmver, $wanted, "\n");
}

eval { $v .= pmver('Capture::Tiny','any version') };
eval { $v .= pmver('Carp','any version') };
eval { $v .= pmver('Class::Load','any version') };
eval { $v .= pmver('Dist::Zilla','4.300000') };
eval { $v .= pmver('Dist::Zilla::File::FromCode','any version') };
eval { $v .= pmver('Dist::Zilla::Plugin::Authority','any version') };
eval { $v .= pmver('Dist::Zilla::Plugin::AutoPrereqs','4.200011') };
eval { $v .= pmver('Dist::Zilla::Plugin::Bootstrap::lib','any version') };
eval { $v .= pmver('Dist::Zilla::Plugin::CheckExtraTests','any version') };
eval { $v .= pmver('Dist::Zilla::Plugin::ConfirmRelease','any version') };
eval { $v .= pmver('Dist::Zilla::Plugin::EOLTests','0.02') };
eval { $v .= pmver('Dist::Zilla::Plugin::FakeRelease','any version') };
eval { $v .= pmver('Dist::Zilla::Plugin::GatherDir','any version') };
eval { $v .= pmver('Dist::Zilla::Plugin::Git::Check','1.102040') };
eval { $v .= pmver('Dist::Zilla::Plugin::Git::CommitBuild','1.102040') };
eval { $v .= pmver('Dist::Zilla::Plugin::Git::NextVersion','1.102810') };
eval { $v .= pmver('Dist::Zilla::Plugin::Git::Tag','1.102040') };
eval { $v .= pmver('Dist::Zilla::Plugin::GithubMeta','0.08') };
eval { $v .= pmver('Dist::Zilla::Plugin::License','any version') };
eval { $v .= pmver('Dist::Zilla::Plugin::Manifest','any version') };
eval { $v .= pmver('Dist::Zilla::Plugin::ManifestSkip','any version') };
eval { $v .= pmver('Dist::Zilla::Plugin::MetaConfig','any version') };
eval { $v .= pmver('Dist::Zilla::Plugin::MetaData::BuiltWith','0.01014716') };
eval { $v .= pmver('Dist::Zilla::Plugin::MetaJSON','any version') };
eval { $v .= pmver('Dist::Zilla::Plugin::MetaProvides','1.12044518') };
eval { $v .= pmver('Dist::Zilla::Plugin::MetaProvides::Package','1.14000001') };
eval { $v .= pmver('Dist::Zilla::Plugin::MetaTests','any version') };
eval { $v .= pmver('Dist::Zilla::Plugin::MetaYAML','any version') };
eval { $v .= pmver('Dist::Zilla::Plugin::MinimumPerl','any version') };
eval { $v .= pmver('Dist::Zilla::Plugin::ModuleBuild','any version') };
eval { $v .= pmver('Dist::Zilla::Plugin::PkgVersion','any version') };
eval { $v .= pmver('Dist::Zilla::Plugin::PodCoverageTests','any version') };
eval { $v .= pmver('Dist::Zilla::Plugin::PodSyntaxTests','any version') };
eval { $v .= pmver('Dist::Zilla::Plugin::PodWeaver','3.093321') };
eval { $v .= pmver('Dist::Zilla::Plugin::Prereqs','any version') };
eval { $v .= pmver('Dist::Zilla::Plugin::PruneCruft','any version') };
eval { $v .= pmver('Dist::Zilla::Plugin::ReadmeFromPod','0.12') };
eval { $v .= pmver('Dist::Zilla::Plugin::ReportVersions::Tiny','1.01') };
eval { $v .= pmver('Dist::Zilla::Plugin::Test::CPAN::Changes','any version') };
eval { $v .= pmver('Dist::Zilla::Plugin::Test::Compile','1.112400') };
eval { $v .= pmver('Dist::Zilla::Plugin::Test::Kwalitee','1.112410') };
eval { $v .= pmver('Dist::Zilla::Plugin::Test::MinimumVersion','any version') };
eval { $v .= pmver('Dist::Zilla::Plugin::Test::Perl::Critic','1.102280') };
eval { $v .= pmver('Dist::Zilla::Plugin::TestRelease','any version') };
eval { $v .= pmver('Dist::Zilla::Plugin::Twitter','0.011') };
eval { $v .= pmver('Dist::Zilla::Plugin::UploadToCPAN','any version') };
eval { $v .= pmver('Dist::Zilla::PluginBundle::Author::KENTNL','1.2.0') };
eval { $v .= pmver('Dist::Zilla::PluginBundle::Author::KENTNL::Lite','0.01009803') };
eval { $v .= pmver('Dist::Zilla::Role::FileGatherer','any version') };
eval { $v .= pmver('Dist::Zilla::Role::MintingProfile::ShareDir','any version') };
eval { $v .= pmver('Dist::Zilla::Role::PluginBundle','any version') };
eval { $v .= pmver('File::Find','any version') };
eval { $v .= pmver('File::Temp','any version') };
eval { $v .= pmver('File::pushd','any version') };
eval { $v .= pmver('FindBin','any version') };
eval { $v .= pmver('IO::Socket::SSL','any version') };
eval { $v .= pmver('JSON','any version') };
eval { $v .= pmver('LWP::Protocol::https','6.00') };
eval { $v .= pmver('Module::Build','0.3601') };
eval { $v .= pmver('Moose','1.01') };
eval { $v .= pmver('Moose::Autobox','any version') };
eval { $v .= pmver('MooseX::Has::Sugar','0.05044') };
eval { $v .= pmver('MooseX::Types','0.21') };
eval { $v .= pmver('Net::SSLeay','1.36') };
eval { $v .= pmver('Path::Class','any version') };
eval { $v .= pmver('Perl::PrereqScanner','1.006') };
eval { $v .= pmver('Pod::Coverage::TrustPod','any version') };
eval { $v .= pmver('Pod::Weaver::Plugin::Encoding','any version') };
eval { $v .= pmver('String::Formatter','any version') };
eval { $v .= pmver('Test::CPAN::Meta','any version') };
eval { $v .= pmver('Test::DZil','any version') };
eval { $v .= pmver('Test::EOL','0.9') };
eval { $v .= pmver('Test::Fatal','any version') };
eval { $v .= pmver('Test::File::ShareDir','0.3.0') };
eval { $v .= pmver('Test::More','0.88') };
eval { $v .= pmver('Test::Output','any version') };
eval { $v .= pmver('Test::Perl::Critic','any version') };
eval { $v .= pmver('namespace::autoclean','0.09') };
eval { $v .= pmver('strict','any version') };
eval { $v .= pmver('version','any version') };
eval { $v .= pmver('warnings','any version') };



# All done.
$v .= <<'EOT';

Thanks for using my code.  I hope it works for you.
If not, please try and include this output in the bug report.
That will help me reproduce the issue and solve you problem.

EOT

diag($v);
ok(1, "we really didn't test anything, just reporting data");
$success = 1;

# Work around another nasty module on CPAN. :/
no warnings 'once';
$Template::Test::NO_FLUSH = 1;
exit 0;
