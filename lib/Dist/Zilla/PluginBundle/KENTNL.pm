use strict;
use warnings;

package Dist::Zilla::PluginBundle::KENTNL;

# ABSTRACT: BeLike::KENTNL when you build your dists.

use Moose;
use Moose::Autobox;

with 'Dist::Zilla::Role::PluginBundle';

use namespace::autoclean -also => '_expand';

=head1 DESCRIPTION

This is the plugin bundle that KENTNL uses. It exists mostly because he is very lazy
and wants others to be using what he's using if they want to be doing work on his modules.

=cut

sub _expand {
  my ( $class, $suffix, $record ) = @_;
  return [ $class . '/Dist::Zilla::Plugin::' . $suffix, 'Dist::Zilla::Plugin::' . $suffix, $record ];
}

sub _load {
  my $m = shift;
  eval " require $m; 1" or do {
    my $e = $@;
    require Carp;
    Carp::confess($e);
    }
}

sub bundle_config {
  my ( $self, $section ) = @_;
  my $class = ( ref $self ) || $self;

  my $arg = $section->{payload};
  my @config = map { _expand( $class, $_->[0], $_->[1] ) } (
    [
      'AutoVersion::Relative' => {
        major     => $arg->{version_major}         || 0,
        minor     => $arg->{version_minor}         || 1,
        year      => $arg->{version_rel_year}      || 2010,
        month     => $arg->{version_rel_month}     || 5,
        day       => $arg->{version_rel_day}       || 16,
        hour      => $arg->{version_rel_hour}      || 20,
        time_zone => $arg->{version_rel_time_zone} || 'Pacific/Auckland',
      }
    ],
    [ 'AllFiles'              => {} ],
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
    [ 'CompileTests'          => {} ],
    [ 'MetaTests'             => {} ],
    [ 'PodTests'              => {} ],
    [ 'ExtraTests'            => {} ],
    ( $arg->{nogit} ? () : [ 'Git::Check' => { filename => 'Changes' } ] ),
    [ 'NextRelease' => {} ],
    ( $arg->{nogit} ? () : [ 'Git::Tag' => { filename => 'Changes', tag_format => '%v-source' } ] ),
    ( $arg->{nogit}  ? () : [ 'Git::Commit'  => {} ] ),
    ( $arg->{nocpan} ? () : [ 'UploadToCPAN' => {} ] ),
  );
  _load($_->[0]) for @config;
  return @config;
}
__PACKAGE__->meta->make_immutable;
no Moose;

'I go to prepare a perl module for you, if it were not so, I would have told you';

