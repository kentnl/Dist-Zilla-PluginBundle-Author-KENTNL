use strict;
use warnings;

package Dist::Zilla::PluginBundle::KENTNL;
BEGIN {
  $Dist::Zilla::PluginBundle::KENTNL::VERSION = '0.01001713';
}

# ABSTRACT: BeLike::KENTNL when you build your distributions.

use Moose;
use Moose::Autobox;

with 'Dist::Zilla::Role::PluginBundle';

use namespace::autoclean -also => [qw( _expand _load _defined_or _only_git _only_cpan _release_fail )];


sub _expand {
  my ( $class, $suffix, $conf ) = @_;
  ## no critic ( RequireInterpolationOfMetachars )
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

sub _only_git {
  my ( $args, $ref ) = @_;
  return () if exists $ENV{KENTNL_NOGIT};
  return $ref unless defined $args;
  return $ref unless ref $args eq 'HASH';
  return $ref unless exists $args->{nogit};
  return ();
}

sub _only_cpan {
  my ( $args, $ref ) = @_;
  return () if exists $ENV{KENTNL_NOCPAN};
  return $ref unless defined $args;
  return $ref unless ref $args eq 'HASH';
  return $ref unless exists $args->{nocpan};
  return ();
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
    [ 'GatherDir'             => {} ],
    [ 'MetaConfig'            => {} ],
    [ 'PruneCruft'            => {} ],
    [ 'Repository'            => {} ],
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
    [ 'CompileTests'          => {} ],

    #    [ 'MetaTests'             => {} ],  # TODO: Let this pass x_Dist_Zilla
    [ 'PodCoverageTests' => {} ],
    [ 'PodSyntaxTests'   => {} ],
    [ 'ExtraTests'       => {} ],
    [ 'TestRelease'      => {} ],
    [ 'ConfirmRelease'   => {} ],
    _release_fail($arg),
    _only_git( $arg, [ 'Git::Check' => { filename => 'Changes' } ] ),
    [ 'NextRelease' => {} ],
    _only_git( $arg, [ 'Git::Tag' => { filename => 'Changes', tag_format => '%v-source' } ] ),
    _only_git( $arg, [ 'Git::Commit' => {} ] ),
    _only_cpan( $arg, [ 'UploadToCPAN' => {} ] ),
    _only_cpan( $arg, [ 'Twitter' => { } ] ),
  );
  _load( $_->[1] ) for @config;
  return @config;
}
__PACKAGE__->meta->make_immutable;
no Moose;

## no critic (RequireEndWithOne)
'I go to prepare a perl module for you, if it were not so, I would have told you';


__END__
=pod

=head1 NAME

Dist::Zilla::PluginBundle::KENTNL - BeLike::KENTNL when you build your distributions.

=head1 VERSION

version 0.01001713

=head1 DESCRIPTION

This is the plug-in bundle that KENTNL uses. It exists mostly because he is very lazy
and wants others to be using what he's using if they want to be doing work on his modules.

=head1 METHODS

=head2 bundle_config

See L<Dist::Zilla::Role::PluginBundle> for what this is for, it is a method to satisfy that role.

=head1 AUTHOR

  Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Kent Fredric.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

