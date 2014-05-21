#!/usr/bin/env perl
use strict;
use warnings;
use utf8;

use FindBin;
use lib "$FindBin::Bin/lib";
use Git::Wrapper;
use depsdiff;
use version;
use Version::Next qw(next_version);
use Path::Tiny qw(path);
use Capture::Tiny qw(capture_stdout);

my $git = Git::Wrapper->new('.');

sub file_sha {
  my ( $commit, $path ) = @_;
  my $rev = [ $git->rev_parse($commit) ]->[0];
  my $tree = [ $git->ls_tree( $rev, $path ) ]->[0];
  return unless $tree;
  my ( $left, $right ) = $tree =~ /^([^\t]+)\t(.*$)/;
  my ( $flags, $type, $sha ) = split / /, $left;
  return $sha;
}

my @tags;

for my $line ( reverse $git->RUN( 'log', '--pretty=format:%d', 'releases' ) ) {
  if ( $line =~ /\(tag:\s*([^ ),]+)/ ) {
    my $tag = $1;
    next if $tag =~ /-source$/;
    if ( not eval { version->parse($tag); 1 } ) {
      print "tag $tag skipped\n";
      next;
    }
    push @tags, $tag;

    #print "$tag\n";
    next;
  }
  if ( $line =~ /\(/ ) {
    print "Skipped decoration $line\n";
    next;
  }
}
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
my $changes_opt = CPAN::Changes->new();
my $changes_all = CPAN::Changes->new();
my $changes_dev = CPAN::Changes->new();

my $master_changes = CPAN::Changes->load_string( path('./Changes')->slurp_utf8, next_token => qr/{{\$NEXT}}/ );

while ( @tags > 1 ) {
  my ( $old, $new ) = ( $tags[-2], $tags[-1] );
  print "$old - $new\n";
  pop @tags;

  my $date;
  my $master_release;
  if ( $master_release = $master_changes->release($new) ) {
    $date = $master_release->date();
  }
  else {
    print "$new not on master Changelog\n";
    if ( $new eq 'build/master' ) {
      $master_release = [ $master_changes->releases ]->[-1];
      print " ... using " . $master_release->version . " instead \n";

      #('{{$NEXT}}');
    }
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
  $changes_opt->add_release( {%$params} );
  $changes_all->add_release( {%$params} );
  $changes_dev->add_release( {%$params} );

  my $old_meta_sha1 = file_sha( $old, 'META.json' );
  my $new_meta_sha1 = file_sha( $new, 'META.json' );

  next unless defined $old_meta_sha1 and length $old_meta_sha1;
  next unless defined $new_meta_sha1 and length $new_meta_sha1;

  my $diff = depsdiff->new(
    json_a => ( join qq[\n], $git->cat_file( '-p', $old_meta_sha1 ) ),
    json_b => ( join qq[\n], $git->cat_file( '-p', $new_meta_sha1 ) ),
  );
  $diff->execute;

  $master_release->delete_group('Dependencies::Stats') if $master_release;

  next unless keys %{ $diff->cache };

  if ($master_release) {
    my $phases = {};

    for my $key ( sort keys %{ $diff->cache } ) {
      if ( $key =~ qr{^Dependencies::(\S+)\s+/\s+(\S+)\s+(\S+)$}msx ) {
        my ( $dir, $phase, $rel ) = ( $1, $2, $3 );
        my $phase_m = "$phase";
        if ( not exists $phases->{$phase_m} ) {
          $phases->{$phase_m} = {};
        }
        if ( not exists $phases->{$phase_m}->{$rel} ) {
          $phases->{$phase_m}->{$rel} = { Added => 0, Upgrade => 0, Downgrade => 0, Removed => 0 };
        }

        my $stash = $phases->{$phase_m}->{$rel};

        for my $entry ( @{ $diff->cache->{$key} } ) {
          if ( $dir eq 'Added' or $dir eq 'Removed' ) {
            $stash->{$dir}++;
          }
          else {
            if ( $entry =~ /(\S+)\s+→\s+(\S+)/ ) {
              my ( $lhs, $rhs ) = ( $1, $2 );

              my $lhs_v = version->parse($lhs);
              my $rhs_v = version->parse($rhs);

              if ( $lhs_v < $rhs_v ) {
                $stash->{Upgrade}++;
              }
              else {
                $stash->{Downgrade}++;
              }
            }
          }
        }
      }
    }
    my @changes = ();

    for my $phase ( sort keys %{$phases} ) {

      my $rel_lists = {};

      my $add_thing = sub {
        my ( $name, $token, $minortoken ) = @_;

        for my $rel (qw( requires suggests recommends )) {
          next unless exists $phases->{$phase}->{$rel};
          next unless $phases->{$phase}->{$rel}->{$name} > 0;
          $rel_lists->{$rel} = [] unless exists $rel_lists->{$rel};
          push @{ $rel_lists->{$rel} }, $token . $phases->{$phase}->{$rel}->{$name};
        }
      };

      $add_thing->( 'Added',     '+',   'm' );
      $add_thing->( 'Upgrade',   "↑", 'm' );
      $add_thing->( 'Downgrade', "↓", 'm' );
      $add_thing->( 'Removed',   '-',   'm' );

      my @parts;

      if ( $rel_lists->{requires} ) {
        push @parts, @{ delete $rel_lists->{requires} };
      }
      my @extra;
      for my $rel ( sort keys %{$rel_lists} ) {
        push @extra, sprintf '%s: %s', $rel, join q[ ], @{ $rel_lists->{$rel} };
      }
      if (@extra) {
        push @parts, sprintf '(%s)', join q[, ], @extra;
      }
      if (@parts) {
        push @changes, $phase . ': ' . ( join q[ ], @parts );
      }
    }
    $master_release->add_changes( { group => 'Dependencies::Stats' },
      'Dependencies changed since ' . $old . ', see Changes.deps* for details', @changes );
  }
  for my $key ( sort keys %{ $diff->cache } ) {
    my $label = $key;
    $label =~ s/Dependencies:://msx;
    $changes_all->release($version)->add_changes( { group => $label }, @{ $diff->cache->{$key} } );
    if ( $key !~ /develop/ ) {
      if ( $key =~ /requires/ ) {
          $changes->release($version)->add_changes( { group => $label }, @{ $diff->cache->{$key} } );
      } else {
        $changes_opt->release($version)->add_changes( { group => $label }, @{ $diff->cache->{$key} } );
      }
    }
    else {
      $changes_dev->release($version)->add_changes( { group => $label }, @{ $diff->cache->{$key} } );
    }
  }
}
sub _maybe { return $_[0] if defined $_[0]; return q[] }

path('./Changes.deps.all')->spew_utf8( _maybe( $changes_all->serialize ) );
path('./Changes.deps')->spew_utf8( _maybe( $changes->serialize ) );
path('./Changes.deps.opt')->spew_utf8( _maybe( $changes_opt->serialize ) );
path('./Changes.deps.dev')->spew_utf8( _maybe( $changes_dev->serialize ) );
path('./Changes')->spew_utf8( _maybe( $master_changes->serialize ) );
