use 5.004; # __PACKAGE__
use strict;
use warnings;

package Dist::Zilla::PluginBundle::Author::KENTNL;
BEGIN {
  $Dist::Zilla::PluginBundle::Author::KENTNL::AUTHORITY = 'cpan:KENTNL';
}
{
  $Dist::Zilla::PluginBundle::Author::KENTNL::VERSION = '2.007002';
}

# ABSTRACT: BeLike::KENTNL when you build your distributions.

use Moose;
use Moose::Util::TypeConstraints qw(enum);
use MooseX::StrictConstructor;
use MooseX::AttributeShortcuts;

with 'Dist::Zilla::Role::PluginBundle';
with 'Dist::Zilla::Role::BundleDeps';

use namespace::autoclean -also => [qw( _expand _defined_or _only_git _only_cpan _release_fail _only_fiveten )];






sub mvp_multivalue_args { return qw( auto_prereqs_skip ) }

has plugins => ( is => ro =>, isa => 'ArrayRef', init_arg => undef, lazy => 1, builder => sub { [] } );

has normal_form => ( is => ro =>, isa => 'Str', builder => sub { 'numify' } );
has mantissa    => ( is => ro =>, isa => 'Int', builder => sub { 6 } );
has git_versions => ( is => 'ro', isa => enum( [1] ), required => 1, );
has authority               => ( is => 'ro', isa   => 'Str',      lazy => 1, builder => sub { 'cpan:KENTNL' }, );
has auto_prereqs_skip       => ( is => 'ro', isa   => 'ArrayRef', lazy => 1, builder => sub { [] }, );
has twitter_extra_hash_tags => ( is => 'ro', 'isa' => 'Str',      lazy => 1, builder => sub { q[] }, );
has twitter_hash_tags       => (
  is      => 'ro',
  isa     => 'Str',
  lazy    => 1,
  builder => sub {
    my ($self) = @_;
    return '#perl #cpan' unless $self->has_twitter_extra_hash_tags;
    return '#perl #cpan ' . $self->twitter_extra_hash_tags;
  },
);
has tweet_url => (
  is      => 'ro',
  isa     => 'Str',
  lazy    => 1,
  builder => sub {
    ## no critic (RequireInterpolationOfMetachars)
    return q[https://metacpan.org/source/{{$AUTHOR_UC}}/{{$DIST}}-{{$VERSION}}{{$TRIAL}}/Changes];
  },
);


sub add_plugin {
  my ( $self, $suffix, $conf ) = @_;
  if ( not defined $conf ) {
    $conf = {};
  }
  if ( not ref $conf or not ref $conf eq 'HASH' ) {
    require Carp;
    Carp::croak('Conf must be a hash');
  }
  ## no critic (RequireInterpolationOfMetachars)
  push @{ $self->plugins }, [ q{@Author::KENTNL/} . $suffix, 'Dist::Zilla::Plugin::' . $suffix, $conf ];
  return;
}


sub add_named_plugin {
  my ( $self, $name, $suffix, $conf ) = @_;
  if ( not defined $conf ) {
    $conf = {};
  }
  if ( not ref $conf or not ref $conf eq 'HASH' ) {
    require Carp;
    Carp::croak('Conf must be a hash');
  }
  ## no critic (RequireInterpolationOfMetachars)
  push @{ $self->plugins }, [ q{@Author::KENTNL/} . $name, 'Dist::Zilla::Plugin::' . $suffix, $conf ];
  return;
}


sub configure {
  my ($self) = @_;

  # Version
  $self->add_plugin(
    'Git::NextVersion::Sanitized' => {
      version_regexp => '^(.*)-source$',
      first_version  => '0.001000',
      normal_form    => $self->normal_form,
      mantissa       => $self->mantissa,
    }
  );

  # Metadata
  $self->add_plugin( 'MetaConfig' => {} );

  $self->add_plugin( 'GithubMeta' => { issues => 1 } );

  $self->add_plugin( 'MetaProvides::Package' => { ':version' => '1.14000001' } );

  if ( $^O eq 'linux' ) {
    $self->add_plugin( 'MetaData::BuiltWith' => { show_uname => 1, uname_args => q{ -s -o -r -m -i }, show_config => 1 } );
  }
  else {
    $self->add_plugin( 'MetaData::BuiltWith' => { show_config => 1 } );
  }

  # Gather Files

  $self->add_plugin( 'Git::GatherDir' => { include_dotfiles => 1 } );
  $self->add_plugin( 'License'        => {} );
  $self->add_plugin( 'MetaJSON'       => {} );
  $self->add_plugin( 'MetaYAML'       => {} );
  $self->add_plugin( 'Manifest'       => {} );
  $self->add_plugin( 'MetaTests'      => {} );
  $self->add_plugin( 'PodCoverageTests'       => {} );
  $self->add_plugin( 'PodSyntaxTests'         => {} );
  $self->add_plugin( 'ReportVersions::Tiny'   => {} );
  $self->add_plugin( 'Test::Kwalitee'         => {} );
  $self->add_plugin( 'EOLTests'               => { trailing_whitespace => 1, } );
  $self->add_plugin( 'Test::MinimumVersion'   => {} );
  $self->add_plugin( 'Test::Compile::PerFile' => {} );
  $self->add_plugin( 'Test::Perl::Critic'     => {} );

  # Prune files

  $self->add_plugin( 'ManifestSkip' => {} );

  # Mungers
  $self->add_plugin( 'PkgVersion'  => {} );
  $self->add_plugin( 'PodWeaver'   => {} );
  $self->add_plugin( 'NextRelease' => { time_zone => 'UTC', format => q[%v %{yyyy-MM-dd'T'HH:mm:ss}dZ] } );

  # Prereqs

  $self->add_plugin( 'AutoPrereqs' => { skip => $self->auto_prereqs_skip } );
  $self->add_named_plugin(
    'BundleDevelSuggests' => 'Prereqs' => {
      -phase                                            => 'develop',
      -type                                             => 'suggests',
      'Dist::Zilla::PluginBundle::Author::KENTNL::Lite' => '1.3.0',
    }
  );
  $self->add_named_plugin(
    'BundleDevelRequires' => 'Prereqs' => {
      -phase                                      => 'develop',
      -type                                       => 'requires',
      'Dist::Zilla::PluginBundle::Author::KENTNL' => '1.3.0',
    }
  );

  $self->add_plugin( 'MinimumPerl' => {} );
  $self->add_plugin( 'Authority' => { ':version' => '1.006', authority => $self->authority, do_metadata => 1 } );

  $self->add_plugin( 'ModuleBuild'   => {} );
  $self->add_plugin( 'ReadmeFromPod' => {} );
  $self->add_plugin(
    'ReadmeAnyFromPod' => {
      type     => 'markdown',
      filename => 'README.mkdn',
      location => 'root',
    }
  );
  $self->add_plugin( 'Test::CPAN::Changes' => {} );
  $self->add_plugin( 'RunExtraTests'       => {} );
  $self->add_plugin( 'TestRelease'         => {} );
  $self->add_plugin( 'ConfirmRelease'      => {} );

  $self->add_plugin( 'Git::Check' => { filename => 'Changes' } );
  $self->add_named_plugin( 'tag_master', => 'Git::Tag' => { tag_format => '%v-source' } );
  $self->add_plugin( 'Git::Commit' => {} );
  $self->add_plugin( 'Git::CommitBuild' => { release_branch => 'releases' } );
  $self->add_named_plugin( 'tag_release', 'Git::Tag' => { branch => 'releases', tag_format => '%v' } );
  $self->add_plugin( 'UploadToCPAN' => {} );
  $self->add_plugin( 'Twitter' => { hash_tags => $self->twitter_hash_tags, tweet_url => $self->tweet_url } );
  $self->add_plugin(
    'Prereqs::MatchInstalled' => {
      modules => [qw( Module::Build Test::More Dist::Zilla::PluginBundle::Author::KENTNL )],
    }
  );
  return;
}

sub bundle_config {
  my ( $self, $section ) = @_;
  my $class = ( ref $self ) || $self;

  my $wanted_version;
  if ( exists $section->{payload}->{':version'} ) {
    $wanted_version = delete $section->{payload}->{':version'};
  }
  my $instance = $class->new( $section->{payload} );

  $instance->configure();

  return @{ $instance->plugins };
}

__PACKAGE__->meta->make_immutable;
no Moose;
## no critic (RequireEndWithOne)
'I go to prepare a perl module for you, if it were not so, I would have told you';

__END__

=pod

=encoding UTF-8

=head1 NAME

Dist::Zilla::PluginBundle::Author::KENTNL - BeLike::KENTNL when you build your distributions.

=head1 VERSION

version 2.007002

=head1 SYNOPSIS

    [@Author::KENTNL]
    no_cpan = 1 ; skip upload to cpan and twitter.
    no_git  = 1 ; skip things that work with git.
    release_fail = 1 ; asplode!.
    git_versions = 1 ;  use git::nextversion for versioning

=head1 DESCRIPTION

This is the plug-in bundle that KENTNL uses. It exists mostly because he is very lazy
and wants others to be using what he's using if they want to be doing work on his modules.

=head1 NAMING SCHEME

As I blogged about on L<< C<blog.fox.geek.nz> : Making a Minting Profile as a CPANized Dist |http://bit.ly/hAwl4S >>,
this bundle advocates a new naming system for people who are absolutely convinced they want their C<Author-Centric> distribution uploaded to CPAN.

As we have seen with Dist::Zilla there have been a slew of PluginBundles with CPANID's in their name, to the point that there is a copious amount of name-space pollution
in the PluginBundle name-space, and more Author bundles than task-bundles, which was really what the name-space was designed for, and I'm petitioning you to help reduce
this annoyance in future modules.

From a CPAN testers perspective, the annoyance of lots of CPANID-dists is similar to the annoyance of the whole DPCHRIST:: subspace, and that if this pattern continues,
it will mean for the testers who do not wish to test everyones personal modules, that they will have to work hard to avoid this. If DPCHRIST:: had used something like
Author::DPCHRIST:: instead, I doubt so many people would be horrified by it, because you can just have a policy/rule that excludes ^Author::, and everyone else who goes
that way can be quietly ignored.

Then we could probably rationally add that same restriction to the irc announce bots, the "recent modules" list and so-forth, and possibly even apply special indexing restrictions
or something so people wouldn't even have to know those modules exist on cpan!

So, for the sake of cleanliness, semantics, and general global sanity, I ask you to join me with my Author:: naming policy to voluntarily segregate modules that are most
likely of only personal use from those that have more general application.

    Dist::Zilla::Plugin::Foo                    # [Foo]                 dist-zilla plugins for general use
    Dist::Zilla::Plugin::Author::KENTNL::Foo    # [Author::KENTNL::Foo] foo that only KENTNL will probably have use for
    Dist::Zilla::PluginBundle::Classic          # [@Classic]            A bundle that can have practical use by many
    Dist::Zilla::PluginBundle::Author::KENTNL   # [@Author::KENTNL]     KENTNL's primary plugin bundle
    Dist::Zilla::MintingProfile::Default        # A minting profile that is used by all
    Dist::Zilla::MintingProfile::Author::KENTNL # A minting profile that only KENTNL will find of use.

=head2 Current Proponents

I wish to give proper respect to the people out there already implementing this scheme:

=over 4

=item L<< C<@Author::DOHERTY> |Dist::Zilla::PluginBundle::Author::DOHERTY >> - Mike Doherty's, Author Bundle.

=item L<< C<@Author::OLIVER> |Dist::Zilla::PluginBundle::Author::OLIVER >> - Oliver Gorwits', Author Bundle.

=item L<< C<Dist::Zilla::PluginBundle::Author::> namespace |http://bit.ly/dIovQI >> - Oliver Gorwit's blog on the subject.

=item L<< C<@Author::LESPEA> |Dist::Zilla::PluginBundle::Author::LESPEA >> - Adam Lesperance's, Author Bundle.

=item L<< C<@Author::ALEXBIO> |Dist::Zilla::PluginBundle::Author::ALEXBIO >> - Alessandro Ghedini's, Author Bundle.

=item L<< C<@Author::RWSTAUNER> |Dist::Zilla::PluginBundle::Author::RWSTAUNER >> - Randy Stauner's, Author Bundle.

=item L<< C<@Author::WOLVERIAN> |Dist::Zilla::PluginBundle::Author::WOLVERIAN >> - Ilmari Vacklin's, Author Bundle.

=item L<< C<@Author::YANICK> |Dist::Zilla::PluginBundle::Author::YANICK >> - Yanick Champoux's, Author Bundle.

=item L<< C<@Author::RUSSOZ> |Dist::Zilla::PluginBundle::Author::RUSSOZ >> - Alexei Znamensky's, Author Bundle.

=back

=head1 METHODS

=head2 C<bundle_config>

See L<< the C<PluginBundle> role|Dist::Zilla::Role::PluginBundle >> for what this is for, it is a method to satisfy that role.

=head2 C<add_plugin>

    $bundle_object->add_plugin("Basename" => { config_hash } );

=head2 C<add_named_plugin>

    $bundle_object->add_named_plugin("alias" => "Basename" => { config_hash } );

=head2 C<configure>

Called by in C<bundle_config> after C<new>

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Dist::Zilla::PluginBundle::Author::KENTNL",
    "interface":"class",
    "inherits":"Moose::Object",
    "does":"Dist::Zilla::Role::PluginBundle"
}


=end MetaPOD::JSON

=for Pod::Coverage   mvp_multivalue_args
  bundle_config_inner

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Kent Fredric.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
