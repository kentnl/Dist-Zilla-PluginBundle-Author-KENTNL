
use strict;
use warnings;

use Test::More;
use FindBin;
use Path::Class qw( dir );
use Test::File::ShareDir
  -root  => "$FindBin::Bin/../",
  -share => { -module => { 'Dist::Zilla::MintingProfile::Author::KENTNL' => 'share/profiles' }, };
use Test::DZil;

my $tzil = Minter->_new_from_profile(
  [ 'Author::KENTNL'   => 'default' ],
  { name               => 'DZT-Minty', },
  { global_config_root => dir("$FindBin::Bin/../corpus/global") },
);
$tzil->chrome->logger->set_debug(1);
$tzil->mint_dist;

system("find",$tzil->tempdir );

my $bzil = Builder->from_config(
  { dist_root => $tzil->tempdir->subdir('mint') },
  {}, { global_config_root => dir("$FindBin::Bin/../corpus/global") },
);
$bzil->chrome->logger->set_debug(1);


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

  note explain { got => \%got_files, expected => \%expected_files };

  is_deeply( \%got_files, \%expected_files, 'All expected mint files exist' );

};

subtest 'build minting' => sub {

  eval {
    $bzil->test;
  }

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

  is_deeply( \%got_files, \%expected_files, 'All expected mint files exist' );


};

done_testing;

