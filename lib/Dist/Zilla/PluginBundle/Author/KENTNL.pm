use strict;
use warnings;

package Dist::Zilla::PluginBundle::Author::KENTNL;
BEGIN {
  $Dist::Zilla::PluginBundle::Author::KENTNL::AUTHORITY = 'cpan:KENTNL';
}
{
  $Dist::Zilla::PluginBundle::Author::KENTNL::VERSION = '1.7.0';
}

# ABSTRACT: BeLike::KENTNL when you build your distributions.

use Moose;
use Moose::Autobox;
use Class::Load qw( :all );

with 'Dist::Zilla::Role::PluginBundle';

use namespace::autoclean -also => [qw( _expand _defined_or _only_git _only_cpan _release_fail _only_fiveten )];




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
    return @rest unless exists $args->{ 'no_' . $argfield };
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
  _mk_only(qw( fiveten FIVETEN fiveten ));
  _mk_only(qw( ghissues GHISSUES ghissues ));
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

sub _params_list {
  return (
    qw( :version authority auto_prereqs_skip git_versions twitter_only release_fail no_cpan no_git no_twitter twitter_hash_tags twitter_extra_hash_tags release_fail no_fiveten )
  );
}

sub _param_checker {
  my $_self = shift;

  my %params_hash = map { $_ => 1 } $_self->_params_list;

  return sub {

    my ( $self, $param ) = @_;
    if ( not exists $params_hash{$param} ) {
      require Carp;
      Carp::croak("[Author::KENTNL] Parameter $param doesn't appear to be supported");
    }

  };
}


sub mvp_multivalue_args { return qw( auto_prereqs_skip ) }

sub bundle_config_inner {
  my ( $class, $arg ) = @_;

  ## no critic (RequireInterpolationOfMetachars)
  my $twitter_conf = {
    hash_tags => _defined_or( $arg, twitter_hash_tags => '#perl #cpan' ),
    tweet_url => 'https://metacpan.org/source/{{$AUTHOR_UC}}/{{$DIST}}-{{$VERSION}}{{$TRIAL}}/Changes',
  };

  my $extra_hash = _defined_or( $arg, twitter_extra_hash_tags => q{}, 1 );
  $twitter_conf->{hash_tags} .= q{ } . $extra_hash if $extra_hash;

  if ( not exists $arg->{git_versions} ) {
    require Carp;
    Carp::croak('Sorry, Git based versions are now mandatory');
  }

  my $checker = $class->_param_checker;

  for my $param ( keys %{$arg} ) {
    $checker->( $class, $param );
  }

  if ( not defined $arg->{authority} ) {
    $arg->{authority} = 'cpan:KENTNL';
  }
  if ( not defined $arg->{auto_prereqs_skip} ) {
    $arg->{auto_prereqs_skip} = [];
  }

  if ( not ref $arg->{auto_prereqs_skip} eq 'ARRAY' ) {
    require Carp;
    Carp::carp('[Author::KENTNL] auto_prereqs_skip is expected to be an array ref');
  }

  my (@version) = ( [ 'Git::NextVersion' => { version_regexp => '^(.*)-source$', first_version => '0.1.0' } ], );
  my (@metadata) = (
    [ 'MetaConfig' => {} ],
    _only_git( $arg, [ 'GithubMeta' => { _only_ghissues( $arg, issues => 1 ), } ] ),
    [ 'MetaProvides::Package' => {} ],
    [
      'MetaData::BuiltWith' => { $^O eq 'linux' ? ( show_uname => 1, uname_args => q{ -s -o -r -m -i } ) : (), show_config => 1 }
    ],

  );

  my (@sharedir) = ();

  my (@gatherfiles) = (
    [ 'Git::GatherDir'       => { include_dotfiles    => 1 } ],
    [ 'License'              => {} ],
    [ 'MetaJSON'             => {} ],
    [ 'MetaYAML'             => {} ],
    [ 'Manifest'             => {} ],
    [ 'MetaTests'            => {} ],
    [ 'PodCoverageTests'     => {} ],
    [ 'PodSyntaxTests'       => {} ],
    [ 'ReportVersions::Tiny' => {} ],
    [ 'Test::Kwalitee'       => {} ],
    [ 'EOLTests'             => { trailing_whitespace => 1, } ],
    [ 'Test::MinimumVersion' => {} ],
    [ 'Test::Compile'        => {} ],
    [ 'Test::Perl::Critic'   => {} ],
  );

  my (@prunefiles) = ( [ 'PruneCruft' => { except => '^.perltidyrc' } ], [ 'ManifestSkip' => {} ], );

  my (@regprereqs) = (
    [ 'AutoPrereqs' => { skip => $arg->{auto_prereqs_skip} } ],
    [
      'Prereqs' => {
        -name                                             => 'BundleDevelNeeds',
        -phase                                            => 'develop',
        -type                                             => 'requires',
        'Dist::Zilla::PluginBundle::Author::KENTNL::Lite' => 0
      }
    ],
    [
      'Prereqs' => {
        -name                                             => 'BundleDevelRecommends',
        -phase                                            => 'develop',
        -type                                             => 'recommends',
        'Dist::Zilla::PluginBundle::Author::KENTNL::Lite' => '1.3.0',
      }
    ],
    [
      'Prereqs' => {
        -name                                       => 'BundleDevelSuggests',
        -phase                                      => 'develop',
        -type                                       => 'suggests',
        'Dist::Zilla::PluginBundle::Author::KENTNL' => '1.3.0',
      }
    ],
    [ 'Author::KENTNL::MinimumPerl'                => { _only_fiveten( $arg, fiveten => 1 ) } ],
    [ 'Author::KENTNL::Prereqs::Latest::Selective' => {} ],
  );
  my (@mungers) = (
    [ 'PkgVersion'  => {} ],
    [ 'PodWeaver'   => {} ],
    [ 'NextRelease' => { time_zone => 'UTC', format => q[%v %{yyyy-MM-dd'T'HH:mm:ss}dZ] } ],
  );

  return (
    @version,
    @metadata,
    @sharedir,
    @gatherfiles,
    @prunefiles,
    @mungers,
    @regprereqs,
    [ 'Authority'           => { authority => $arg->{authority}, do_metadata => 1 } ],
    [ 'ModuleBuild'         => {} ],
    [ 'ReadmeFromPod'       => {} ],
    [ 'ReadmeAnyFromPod'    => { 
            type => 'markdown',
            filename => 'README.mkdn',
            location => 'root',
    } ],
    [ 'Test::CPAN::Changes' => {} ],
    [ 'CheckExtraTests'     => {} ],
    [ 'TestRelease'         => {} ],
    [ 'ConfirmRelease'      => {} ],
    _release_fail($arg),
    _only_git( $arg, [ 'Git::Check' => { filename => 'Changes' } ] ),
    _only_git( $arg, [ [ 'Git::Tag', 'tag_master' ] => { tag_format => '%v-source' } ] ),
    _only_git( $arg, [ 'Git::Commit' => {} ] ),
    _only_git( $arg, [ 'Git::CommitBuild' => { release_branch => 'releases' } ] ),
    _only_git( $arg, [ [ 'Git::Tag', 'tag_release' ] => { branch => 'releases', tag_format => '%v' } ] ),
    _only_cpan( $arg, [ 'UploadToCPAN' => {} ] ),
    [ 'Twitter' => $twitter_conf ],
  );
}

sub bundle_config {
  my ( $self, $section ) = @_;
  my $class = ( ref $self ) || $self;

  my $arg = $section->{payload};

  my @config = map { _expand( $class, $_->[0], $_->[1] ) } $class->bundle_config_inner($arg);
  load_class( $_->[1] ) for @config;
  return @config;
}

__PACKAGE__->meta->make_immutable;
no Moose;

## no critic (RequireEndWithOne)
'I go to prepare a perl module for you, if it were not so, I would have told you';

__END__

=pod

=encoding utf-8

=head1 NAME

Dist::Zilla::PluginBundle::Author::KENTNL - BeLike::KENTNL when you build your distributions.

=head1 VERSION

version 1.7.0

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

=head1 ENVIRONMENT

all of these have to merely exist to constitute a "true" status.

=head2 KENTNL_NOGIT

the same as no_git=1

=head2 KENTNL_NOCPAN

same as no_cpan = 1

=head2 KENTNL_RELEASE_FAIL

same as release_fail=1

=for Pod::Coverage   mvp_multivalue_args
  bundle_config_inner

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
