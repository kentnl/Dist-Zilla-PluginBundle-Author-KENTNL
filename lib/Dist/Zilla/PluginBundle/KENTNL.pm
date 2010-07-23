use strict;
use warnings;

package Dist::Zilla::PluginBundle::KENTNL;

# ABSTRACT: BeLike::KENTNL when you build your distributions.

use Moose;
use Moose::Autobox;

with 'Dist::Zilla::Role::PluginBundle';

use namespace::autoclean -also => [qw( _expand _load _defined_or _only_git _only_cpan _release_fail )];

=head1 SYNOPSIS

    [@KENTNL]
    no_cpan = 1 ; skip upload to cpan and twitter.
    no_git  = 1 ; skip things that work with git.
    twitter_only = 1 ; skip uploading to cpan, don't git, but twitter with fakerelease.
    release_fail = 1 ; asplode!. ( non-twitter only )

=head1 DESCRIPTION

This is the plug-in bundle that KENTNL uses. It exists mostly because he is very lazy
and wants others to be using what he's using if they want to be doing work on his modules.

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
    return [ q{@KENTNL/} . $corename . '/' . $rename, 'Dist::Zilla::Plugin::' . $corename, $conf ];

  }
  return [ q{@KENTNL/} . $suffix, 'Dist::Zilla::Plugin::' . $suffix, $conf ];
}

sub _load {
  my $m = shift;
  eval " require $m ; 1" or do {
    ## no critic (ProhibitPunctuationVars)
    my $e = $@;
    require Carp;
    Carp::confess($e);
  };
  return;
}

=method bundle_config

See L<Dist::Zilla::Role::PluginBundle> for what this is for, it is a method to satisfy that role.

=cut

sub _defined_or {

  # Backcompat way of doing // in < 5.10
  my ( $hash, $field, $default ) = @_;
  if ( not( defined $hash && ref $hash eq 'HASH' && exists $hash->{$field} && defined $hash->{$field} ) ) {
    require Carp;
    ## no critic (RequireInterpolationOfMetachars)
    Carp::carp( '[@KENTNL]' . " Warning: autofilling $field with $default " );
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

sub bundle_config {
  my ( $self, $section ) = @_;
  my $class = ( ref $self ) || $self;

  my $arg = $section->{payload};

  my @config = map { _expand( $class, $_->[0], $_->[1] ) } (
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
    ],
    [ 'GatherDir'  => {} ],
    [ 'MetaConfig' => {} ],
    [ 'PruneCruft' => {} ],
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
    [ 'AutoPrereq'            => {} ],
    [ 'MetaData::BuiltWith'   => {} ],
    [ 'CompileTests'          => {} ],
    [ 'MetaTests'             => {} ],
    [ 'PodCoverageTests'      => {} ],
    [ 'PodSyntaxTests'        => {} ],
    [ 'ReportVersions::Tiny'  => {} ],
    [ 'KwaliteeTests'         => {} ],
    [ 'PortabilityTests'      => {} ],
    [ 'EOLTests'              => { trailing_whitespace => 1, } ],
    [ 'ExtraTests'            => {} ],
    [ 'TestRelease'           => {} ],
    [ 'ConfirmRelease'        => {} ],
    _if_twitter(
      $arg,
      [ [ 'FakeRelease' => { user => 'KENTNL' }, ], [ 'Twitter' => {}, ], ],
      [
        _release_fail($arg),
        _only_git( $arg, [ 'Git::Check' => { filename => 'Changes' } ] ),
        [ 'NextRelease' => {} ],
        _only_git( $arg, [ [ 'Git::Tag', 'tag_master' ] => { filename => 'Changes', tag_format => '%v-source' } ] ),
        _only_git( $arg, [ 'Git::Commit' => {} ] ),
        _only_git( $arg, [ 'Git::CommitBuild' => { release_branch => 'releases' } ] ),
        _only_git( $arg, [ [ 'Git::Tag', 'tag_release' ] => { filename => 'Changes', tag_format => '%v' } ] ),
        _only_cpan( $arg, [ 'UploadToCPAN' => {} ] ),
        _only_cpan( $arg, _only_twitter( $arg, [ 'Twitter' => {} ] ) ),
      ]
    )
  );
  _load( $_->[1] ) for @config;
  return @config;
}
__PACKAGE__->meta->make_immutable;
no Moose;

## no critic (RequireEndWithOne)
'I go to prepare a perl module for you, if it were not so, I would have told you';

