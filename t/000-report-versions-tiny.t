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
    my $want = "any version";
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
    return sprintf('%-40s => %-10s%-15s%s', $module, $pmver, $wanted, "\n");
}

eval { $v .= pmver('Carp','any version') };
eval { $v .= pmver('Dist::Zilla','4.101582') };
eval { $v .= pmver('Dist::Zilla::File::FromCode','any version') };
eval { $v .= pmver('Dist::Zilla::Plugin::AutoVersion::Relative','0.01006104') };
eval { $v .= pmver('Dist::Zilla::Plugin::CompileTests','1.092870') };
eval { $v .= pmver('Dist::Zilla::Plugin::EOLTests','0.02') };
eval { $v .= pmver('Dist::Zilla::Plugin::Git','1.093410') };
eval { $v .= pmver('Dist::Zilla::Plugin::KwaliteeTests','1.101420') };
eval { $v .= pmver('Dist::Zilla::Plugin::MetaProvides','1.10027518') };
eval { $v .= pmver('Dist::Zilla::Plugin::PodWeaver','3.093321') };
eval { $v .= pmver('Dist::Zilla::Plugin::PortabilityTests','1.101420') };
eval { $v .= pmver('Dist::Zilla::Plugin::ReadmeFromPod','0.12') };
eval { $v .= pmver('Dist::Zilla::Plugin::ReportVersions::Tiny','1.01') };
eval { $v .= pmver('Dist::Zilla::Plugin::Repository','0.11') };
eval { $v .= pmver('Dist::Zilla::Plugin::Twitter','0.007') };
eval { $v .= pmver('Dist::Zilla::Role::FileGatherer','any version') };
eval { $v .= pmver('Dist::Zilla::Role::PluginBundle','any version') };
eval { $v .= pmver('File::Find','any version') };
eval { $v .= pmver('File::Spec','any version') };
eval { $v .= pmver('File::Temp','any version') };
eval { $v .= pmver('FindBin','any version') };
eval { $v .= pmver('IO::Socket::SSL','any version') };
eval { $v .= pmver('Module::Build','0.3601') };
eval { $v .= pmver('Moose','1.01') };
eval { $v .= pmver('Moose::Autobox','any version') };
eval { $v .= pmver('MooseX::Has::Sugar','0.0405') };
eval { $v .= pmver('MooseX::Types','0.21') };
eval { $v .= pmver('Net::SSLeay','1.36') };
eval { $v .= pmver('Pod::Coverage::TrustPod','any version') };
eval { $v .= pmver('String::Formatter','any version') };
eval { $v .= pmver('Test::CPAN::Meta','any version') };
eval { $v .= pmver('Test::EOL','0.7') };
eval { $v .= pmver('Test::More','0.88') };
eval { $v .= pmver('Test::Perl::Critic','any version') };
eval { $v .= pmver('namespace::autoclean','0.09') };



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
