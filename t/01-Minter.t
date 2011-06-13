
use strict;
use warnings;

use Test::More;
use FindBin;
use Test::File::ShareDir
  -root  => "$FindBin::Bin/../",
  -share => { -module => { 'Dist::Zilla::MintingProfile::Author::KENTNL' => 'share/profiles' }, };
use Test::DZil;

my $tzil = Minter->_new_from_profile(
  [ 'Author::KENTNL' => 'default' ],
  { name => 'DZT-Minty', }
  { global_config_root => "$FindBin::Bin/../corpus/global" },
);

$tzil->mint_dist;


done_testing;

