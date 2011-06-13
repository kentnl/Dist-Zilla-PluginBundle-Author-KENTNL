
use strict;
use warnings;

use Test::More;
use FindBin;
use Path::Class qw( dir );

my ( $root, $corpus );

BEGIN {
  $root   = dir("$FindBin::Bin")->parent->absolute;
  $corpus = $root->subdir('corpus')->subdir('global');
}
use Test::File::ShareDir -share =>
  { -module => { 'Dist::Zilla::MintingProfile::Author::KENTNL' => $root->subdir('share')->subdir('profiles') }, };
use Test::DZil;

my $tzil =
  Minter->_new_from_profile( [ 'Author::KENTNL' => 'default' ], { name => 'DZT-Minty', }, { global_config_root => $corpus }, );
$tzil->chrome->logger->set_debug(1);
$tzil->mint_dist;

subtest 'mint files' => sub {

  my $pm = $tzil->slurp_file('mint/lib/DZT/Minty.pm');

  my %expected_files = map { $_ => 1 } qw(
    lib/DZT/Minty.pm
    weaver.ini
    perlcritic.rc
    Changes
    .perltidyrc
    .gitignore
    dist.ini
  );

  my %got_files;

  for my $file ( @{ $tzil->files } ) {
    my $name = $file->name;
    $got_files{$name} = 0 if not exists $got_files{$name};
    $got_files{$name} += 1;
  }

  # system("find",$tzil->tempdir );

  for my $dir (qw( .git .git/refs .git/objects lib )) {
    ok( -e $tzil->tempdir->subdir('mint')->subdir($dir), "output dir $dir exists" );
  }

  note explain [ $tzil->log_messages ];

  note explain { got => \%got_files, expected => \%expected_files };

  is_deeply( \%got_files, \%expected_files, 'All expected mint files exist' );

};

subtest 'build minting' => sub {

  my $tmpdir = $tzil->tempdir->subdir('mint')->absolute;

  my $bzil = Builder->from_config( { dist_root => $tmpdir }, {}, { global_config_root => $corpus }, );
  $bzil->chrome->logger->set_debug(1);

  $bzil->build;
  # NOTE: ->test doesn't work atm due to various reasons unknown, so doing it manually.

  require File::pushd;
  my $target = File::pushd::pushd( dir($bzil->tempdir)->subdir('build') );
  eval {
    system ( $^X , 'Build.PL') and die "error with Build.PL\n";
    system ( $^X , 'Build' ) and die "error running $^X Build\n";
    system ( $^X , 'Build', 'test', '--verbose' ) and die "error running $^X Build test\n";
  }
  if( $@ ) {
    warn $@;
    system ( "urxvt -e bash" );
    die $@;
  }

  #  system("find",$bzil->tempdir );

  my %expected_files = map { $_ => 1 } qw(
    lib/DZT/Minty.pm
    weaver.ini
    perlcritic.rc
    Changes
    .perltidyrc
    dist.ini
    Build.PL
    Changes
    LICENSE
    MANIFEST
    META.json
    META.yml
    README
    t/00-compile.t
    t/000-report-versions-tiny.t
    t/author-critic.t
    t/release-cpan-changes.t
    t/release-distmeta.t
    t/release-eol.t
    t/release-kwalitee.t
    t/release-pod-coverage.t
    t/release-pod-syntax.t
  );

  my %got_files;
  for my $file ( @{ $bzil->files } ) {
    my $name = $file->name;
    $got_files{$name} = 0 if not exists $got_files{$name};
    $got_files{$name} += 1;
  }

  note explain { got => \%got_files, expected => \%expected_files };

  note explain [ $bzil->log_messages ];

  is_deeply( \%got_files, \%expected_files, 'All expected mint files exist' );

};

done_testing;

