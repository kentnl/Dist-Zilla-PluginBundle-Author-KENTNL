#!/usr/bin/env perl
use strict;
use warnings;
use utf8;

use FindBin;
use lib "$FindBin::Bin/lib";
use Git::Wrapper;
use version;
use Version::Next qw(next_version);
use Path::Tiny qw(path);
use Capture::Tiny qw(capture_stdout);
use JSON;
use CPAN::Changes::Group::Dependencies::Stats;
use CPAN::Changes::Group::Dependencies::Details;
use CPAN::Changes::Dependencies::Details;
use CPAN::Meta::Prereqs::Diff;
use CPAN::Meta;
use CHI;
use CHI::Driver::FastMmap;
use Cache::FastMmap;

my $git = Git::Wrapper->new('.');

my $cache_root = Path::Tiny::tempdir->parent->child('dep_changes_cache')->stringify;

my $get_sha_cache = CHI->new(
  driver     => 'FastMmap',
  root_dir   => $cache_root,
  namespace  => 'get_sha:' . Path::Tiny::cwd->stringify,
  expires_in => '3m',
);

sub file_sha {
  my ( $commit, $path ) = @_;
  my $rev = [ $git->rev_parse($commit) ]->[0];
  my $tree = [ $git->ls_tree( $rev, $path ) ]->[0];
  return unless $tree;
  my ( $left, $right ) = $tree =~ /^([^\t]+)\t(.*$)/;
  my ( $flags, $type, $sha ) = split / /, $left;
  return $sha;
}

sub get_sha {
  my ($sha)  = @_;
  my $key    = $sha;
  my $result = $get_sha_cache->get($key);
  return $result if defined $result;
  my $out = join qq[\n], $git->cat_file( '-p', $sha );
  $get_sha_cache->set( $key, $out );
  return $out;
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

my $standard_phases = ' (configure/build/runtime/test)';
my $all_phases      = ' (configure/build/runtime/test/develop)';

my $changes = CPAN::Changes::Dependencies::Details->new(
  preamble     => 'This file contains changes in REQUIRED dependencies for standard CPAN phases' . $standard_phases,
  change_types => [qw( Added Changed Removed )],
  phases       => [qw( configure build runtime test )],
  types        => [qw( requires )],
);

my $changes_opt = CPAN::Changes::Dependencies::Details->new(
  preamble => 'This file contains changes in OPTIONAL dependencies for standard CPAN phases' . $standard_phases,
  change_types => [qw( Added Changed Removed )],
  phases       => [qw( configure build runtime test )],
  types        => [qw( recommends suggests )],
);
my $changes_all = CPAN::Changes::Dependencies::Details->new(
  preamble => 'This file contains ALL changes in dependencies in both REQUIRED / OPTIONAL dependencies for all phases'
    . $all_phases,
  change_types => [qw( Added Changed Removed )],
  phases       => [qw( configure build develop runtime test )],
  types        => [qw( requires recommends suggests )],
);
my $changes_dev = CPAN::Changes::Dependencies::Details->new(
  preamble     => 'This file contains changes to DEVELOPMENT dependencies only ( both REQUIRED and OPTIONAL )',
  change_types => [qw( Added Changed Removed )],
  phases       => [qw( develop )],
  types        => [qw( requires recommends suggests )],
);

my $master_changes = CPAN::Changes->load_string( path('./Changes')->slurp_utf8, next_token => qr/\{\{\$NEXT\}\}/ );
$ENV{PERL_JSON_BACKEND} = 'JSON';

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

  my $old_meta_sha1 = file_sha( $old, 'META.json' );
  my $new_meta_sha1 = file_sha( $new, 'META.json' );

  next unless defined $old_meta_sha1 and length $old_meta_sha1;
  next unless defined $new_meta_sha1 and length $new_meta_sha1;

  my $old_meta = CPAN::Meta->load_json_string( get_sha($old_meta_sha1) );
  my $new_meta = CPAN::Meta->load_json_string( get_sha($new_meta_sha1) );

  my $delta = CPAN::Meta::Prereqs::Diff->new(
    old_prereqs => $old_meta,
    new_prereqs => $new_meta,
  );

  if ($master_release) {
    my $pchanges = CPAN::Changes::Group::Dependencies::Stats->new(
      prelude      => [ 'Dependencies changed since ' . $old . ', see misc/*.deps* for details', ],
      prereqs_diff => $delta
    );
    $pchanges->has_changes && $master_release->attach_group($pchanges);
  }
  my $release_info = { %{$params}, prereqs_diff => $delta, };
  $changes->add_release($release_info);
  $changes_opt->add_release($release_info);
  $changes_dev->add_release($release_info);
  $changes_all->add_release($release_info);
}
sub _maybe { return $_[0] if defined $_[0]; return q[] }

$Text::Wrap::columns = 120;
$Text::Wrap::break   = '(?![\x{00a0}\x{202f}])\s';
$Text::Wrap::huge    = 'overflow';

my $misc = path('./misc');
if ( not -d $misc ) {
  $misc->mkpath;
}
$misc->child('Changes.deps.all')->spew_utf8( _maybe( $changes_all->serialize ) );
$misc->child('Changes.deps')->spew_utf8( _maybe( $changes->serialize ) );
$misc->child('Changes.deps.opt')->spew_utf8( _maybe( $changes_opt->serialize ) );
$misc->child('Changes.deps.dev')->spew_utf8( _maybe( $changes_dev->serialize ) );

path('./Changes')->spew_utf8( _maybe( $master_changes->serialize ) );
