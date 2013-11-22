#!/usr/bin/env perl
use strict;
use warnings;
use utf8;

use FindBin;
use lib "$FindBin::Bin/lib";
use Git::Wrapper;
use depsdiff;
use Path::Tiny qw(path);
use Capture::Tiny qw(capture_stdout);

my $git = Git::Wrapper->new('.');

sub file_sha {
  my ( $commit, $path ) = @_;
  my $rev = [ $git->rev_parse($commit) ]->[0];
  my $tree = [ $git->ls_tree( $rev, $path ) ]->[0];
  my ( $left, $right ) = $tree =~ /^([^\t]+)\t(.*$)/;
  my ( $flags, $type, $sha ) = split / /, $left;
  return $sha;
}

my @tags;

for my $tag ( $git->tag() ) {
  next if $tag =~ /-source$/;
  push @tags, $tag;

  #print "$tag\n";
}

use Version::Next qw(next_version);

my $build_master_version;

if ( $ENV{V} ) {
  $build_master_version = $ENV{V};
}
else {
  $build_master_version = next_version( $tags[-1] );
}

push @tags, 'build/master';

use CPAN::Changes;

my $changes     = CPAN::Changes->new();
my $changes_all = CPAN::Changes->new();
my $changes_dev = CPAN::Changes->new();

my $master_changes = CPAN::Changes->load_string( path('./Changes')->slurp_utf8 );

while ( @tags > 2 ) {
  my ( $old, $new ) = ( $tags[-2], $tags[-1] );
  pop @tags;

  my $date;
  if ( my $master_release = $master_changes->release($new) ) {
    $date = $master_release->date();
  }
  my $version = $new;
  if ( $new eq 'build/master' ) {
    $version = $build_master_version;
  }
  my $params = {
    version => $version,
    ( defined $date ? ( date => $date ) : () ),
  };
  $changes->add_release(     {%$params} );
  $changes_all->add_release( {%$params} );
  $changes_dev->add_release( {%$params} );

  my $old_meta_sha1 = file_sha( $old, 'META.json' );
  my $new_meta_sha1 = file_sha( $new, 'META.json' );

  next unless defined $old_meta_sha1 and length $old_meta_sha1;
  next unless defined $new_meta_sha1 and length $new_meta_sha1;

  open my $old_meta, '-|', 'git', 'cat-file', '-p', $old_meta_sha1;
  open my $new_meta, '-|', 'git', 'cat-file', '-p', $new_meta_sha1;

  my $diff = depsdiff->new(
    json_a => ( join qq[\n], $git->cat_file( '-p', $old_meta_sha1 ) ),
    json_b => ( join qq[\n], $git->cat_file( '-p', $new_meta_sha1 ) ),
  );
  $diff->execute;

  #print "\e[31m$new - \e[0m\n";

  for my $key ( sort keys %{ $diff->cache } ) {

    #print "\t\e[32m$key\e[0m\n";
    #for my $value ( @{ $diff->cache->{$key} } ) {
    #    binmode *STDOUT, ':utf8';
    #    print "\t\t$value\n";
    #}
    my $label = $key;
    $label =~ s/Dependencies:://msx;
    $changes_all->release($version)->add_changes( { group => $label }, @{ $diff->cache->{$key} } );
    if ( $key !~ /develop/ ) {
      $changes->release($version)->add_changes( { group => $label }, @{ $diff->cache->{$key} } );
    }
    else {
      $changes_dev->release($version)->add_changes( { group => $label }, @{ $diff->cache->{$key} } );
    }
  }
}
path('./Changes.deps.all')->spew_utf8( $changes_all->serialize );
path('./Changes.deps')->spew_utf8( $changes->serialize );
path('./Changes.deps.dev')->spew_utf8( $changes_dev->serialize );

