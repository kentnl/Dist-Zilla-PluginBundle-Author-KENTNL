
use strict;
use warnings;

use Test::More;
use FindBin;
use Test::File::ShareDir
  -root  => "$FindBin::Bin/../",
  -share => { -module => { 'Dist::Zilla::MintingProfile::Author::KENTNL' => 'share/profiles' }, };
use Test::DZil;


done_testing;

