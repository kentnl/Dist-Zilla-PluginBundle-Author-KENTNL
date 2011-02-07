use strict;
use warnings;

package Dist::Zilla::PluginBundle::Author::KENTNL;

# ABSTRACT: BeLike::KENTNL when you build your distributions.

use Moose;
use Moose::Autobox;
use Class::Load qw( :all );

with 'Dist::Zilla::Role::PluginBundle';

use namespace::autoclean -also => [qw( _expand _defined_or _only_git _only_cpan _release_fail )];

=head1 SYNOPSIS

    [@Author::KENTNL]
    no_cpan = 1 ; skip upload to cpan and twitter.
    no_git  = 1 ; skip things that work with git.
    twitter_only = 1 ; skip uploading to cpan, don't git, but twitter with fakerelease.
    release_fail = 1 ; asplode!. ( non-twitter only )
    git_versions = 1 ;  use git::nextversion for versioning

=head1 DESCRIPTION

This is the plug-in bundle that KENTNL uses. It exists mostly because he is very lazy
and wants others to be using what he's using if they want to be doing work on his modules.

=cut

=head1 NAMING SCHEME

As I blogged about on L<< C<blog.fox.geek.nz> : Making a Minting Profile as a CPANized Dist |http://bit.ly/hAwl4S >>,
this bundle advocates a new naming system for people who are absolutely convinced they want their Author-Centric distribution uploaded to CPAN.

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

=back

=cut

=head1 ENVIRONMENT

all of these have to merely exist to constitute a "true" status.

=head2 KENTNL_NOGIT

the same as no_git=1

=head2 KENTNL_NOCPAN

same as no_cpan = 1

=head2 KENTNL_TWITTER_ONLY

same as twitter_only=1

=head2 KENTNL_RELEASE_FAIL

same as release_fail=1

=cut

sub _expand {
  my ( $class, $suffix, $conf ) = @_;
  ## no critic ( RequireInterpolationOfMetachars )
  if ( ref $suffix ) {
    my ( $corename, $rename ) = @{$suffix};
    if ( exists $conf->{-name} ) {
      $rename = delete $conf->{-name};
    }
    return [ q{@Author::KENTNL/} . $corename . q{/} . $rename, 'Dist::Zilla::Plugin::' . $corename, $conf ];
  }
  if ( exists $conf->{-name} ) {
    my $rename;
    $rename = sprintf q{%s/%s}, $suffix, ( delete $conf->{-name} );
    return [ q{@Author::KENTNL/} . $rename, 'Dist::Zilla::Plugin::' . $suffix, $conf ];

  }
  return [ q{@Author::KENTNL/} . $suffix, 'Dist::Zilla::Plugin::' . $suffix, $conf ];
}

=method bundle_config

See L<< the C<PluginBundle> role|Dist::Zilla::Role::PluginBundle >> for what this is for, it is a method to satisfy that role.

=cut

sub _defined_or {

  # Backcompat way of doing // in < 5.10
  my ( $hash, $field, $default, $nowarn ) = @_;
  $nowarn = 0 if not defined $nowarn;
  if ( not( defined $hash && ref $hash eq 'HASH' && exists $hash->{$field} && defined $hash->{$field} ) ) {
    require Carp;
    ## no critic (RequireInterpolationOfMetachars)
    Carp::carp( '[@Author::KENTNL]' . " Warning: autofilling $field with $default " ) unless $nowarn;
    return $default;
  }
  return $hash->{$field};
}

sub _mk_only {
  my ( $subname, $envname, $argfield ) = @_;
  my $sub = sub {
    my ( $args, @rest ) = @_;
    return () if exists $ENV{ 'KENTNL_NO' . $envname };
    return @rest unless defined $args;
    return @rest unless ref $args eq 'HASH';
    return @rest unless exists $args->{ 'no' . $argfield };
    return ();
  };
  {
    ## no critic (ProhibitNoStrict)
    no strict 'refs';
    *{ __PACKAGE__ . '::_only_' . $subname } = $sub;
  }
  return 1;
}

BEGIN {
  _mk_only(qw( git GIT git ));
  _mk_only(qw( cpan CPAN cpan ));
  _mk_only(qw( twitter TWITTER twitter ));
}

sub _release_fail {
  my ( $args, $ref ) = ( shift, [ 'FakeRelease' => {} ] );
  ## no critic (RequireLocalizedPunctuationVars)

  if ( exists $ENV{KENTNL_RELEASE_FAIL} ) {
    $ENV{DZIL_FAKERELEASE_FAIL} = 1;
    return $ref;
  }
  return () unless defined $args;
  return () unless ref $args eq 'HASH';
  return () unless exists( $args->{release_fail} );
  $ENV{DZIL_FAKERELEASE_FAIL} = 1;
  return $ref;
}

sub _if_twitter {
  my ( $args, $twitter, $else ) = @_;
  return @{$twitter} if ( exists $ENV{KENTNL_TWITTER_ONLY} );
  return @{$twitter} if ( exists $args->{twitter_only} );
  return @{$else};
}

sub _if_git_versions {
  my ( $args, $gitversions, $else ) = @_;
  return @{$gitversions} if exists $ENV{KENTNL_GITVERSIONS};
  return @{$gitversions} if exists $args->{git_versions};
  return @{$else};
}

sub bundle_config {
  my ( $self, $section ) = @_;
  my $class = ( ref $self ) || $self;

  my $arg          = $section->{payload};
  my $twitter_conf = { hash_tags => _defined_or( $arg, twitter_hash_tags => '#perl #cpan' ) };
  my $extra_hash   = _defined_or( $arg, twitter_extra_hash_tags => q{}, 1 );
  $twitter_conf->{hash_tags} .= q{ } . $extra_hash if $extra_hash;

  my @config = map { _expand( $class, $_->[0], $_->[1] ) } (
    [
      _if_git_versions(
        $arg,
        [ 'Git::NextVersion' => { version_regexp => '^(.*)-source$', first_version => '0.1.0' } ],
        [
          'AutoVersion::Relative' => {
            major     => _defined_or( $arg, version_major         => 0 ),
            minor     => _defined_or( $arg, version_minor         => 1 ),
            year      => _defined_or( $arg, version_rel_year      => 2010 ),
            month     => _defined_or( $arg, version_rel_month     => 5 ),
            day       => _defined_or( $arg, version_rel_day       => 16 ),
            hour      => _defined_or( $arg, version_rel_hour      => 20 ),
            time_zone => _defined_or( $arg, version_rel_time_zone => 'Pacific/Auckland' ),
          }
        ]
      )
    ],
    [ 'GatherDir'  => { include_dotfiles => 1 } ],
    [ 'MetaConfig' => {} ],
    [ 'PruneCruft' => { except => '^.perltidyrc' } ],
    _only_git( $arg, [ 'GithubMeta' => {} ] ),
    [ 'License'               => {} ],
    [ 'PkgVersion'            => {} ],
    [ 'PodWeaver'             => {} ],
    [ 'MetaProvides::Package' => {} ],
    [ 'MetaJSON'              => {} ],
    [ 'MetaYAML'              => {} ],
    [ 'ModuleBuild'           => {} ],
    [ 'ReadmeFromPod'         => {} ],
    [ 'ManifestSkip'          => {} ],
    [ 'Manifest'              => {} ],
    [ 'AutoPrereqs'           => {} ],
    [
      'Prereqs' =>
        { -name => 'BundleDevelNeeds', -phase => 'develop', -type => 'requires', 'Dist::Zilla::PluginBundle::Author::KENTNL::Lite' => 0 }
    ],
    [
      'Prereqs' => {
        -name                                     => 'BundleDevelRecommends',
        -phase                                    => 'develop',
        -type                                     => 'recommends',
        'Dist::Zilla::PluginBundle::Author::KENTNL::Lite' => 0.01009803
      }
    ],
    [
      'Prereqs' => {
        -name                               => 'BundleDevelSuggests',
        -phase                              => 'develop',
        -type                               => 'suggests',
        'Dist::Zilla::PluginBundle::Author::KENTNL' => '1.0.0',
      }
    ],

    [ 'MetaData::BuiltWith'  => { show_uname => 1, uname_args => q{ -s -o -r -m -i } } ],
    [ 'CompileTests'         => {} ],
    [ 'CriticTests'          => {} ],
    [ 'MetaTests'            => {} ],
    [ 'PodCoverageTests'     => {} ],
    [ 'PodSyntaxTests'       => {} ],
    [ 'ReportVersions::Tiny' => {} ],
    [ 'KwaliteeTests'        => {} ],
    [ 'EOLTests'       => { trailing_whitespace => 1, } ],
    [ 'ExtraTests'     => {} ],
    [ 'TestRelease'    => {} ],
    [ 'ConfirmRelease' => {} ],
    _if_twitter(
      $arg,
      [ [ 'FakeRelease' => { user => 'KENTNL' }, ], [ 'Twitter' => $twitter_conf, ], ],
      [
        _release_fail($arg),
        _only_git( $arg, [ 'Git::Check' => { filename => 'Changes' } ] ),
        [ 'NextRelease' => {} ],
        _only_git( $arg, [ [ 'Git::Tag', 'tag_master' ] => { tag_format => '%v-source' } ] ),
        _only_git( $arg, [ 'Git::Commit' => {} ] ),
        _only_git( $arg, [ 'Git::CommitBuild' => { release_branch => 'releases' } ] ),
        _only_git( $arg, [ [ 'Git::Tag', 'tag_release' ] => { branch => 'releases', tag_format => '%v' } ] ),
        _only_cpan( $arg, [ 'UploadToCPAN' => {} ] ),
        _only_cpan( $arg, _only_twitter( $arg, [ 'Twitter' => $twitter_conf ] ) ),
      ]
    )
  );
  load_class( $_->[1] ) for @config;
  return @config;
}
__PACKAGE__->meta->make_immutable;
no Moose;

## no critic (RequireEndWithOne)
'I go to prepare a perl module for you, if it were not so, I would have told you';

