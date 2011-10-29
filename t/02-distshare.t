use strict;
use warnings;
use 5.10.0;
use Test::More;
use Test::File::ShareDir v0.3.1 -share => { 
  -dist => { 
    q{a} => q{/home/kent/perl/git/Dist-Zilla-PluginBundle-Author-KENTNL/share/}

#    q{b} => q{share/}
  }
};

use File::ShareDir qw( dist_dir ); 

say dist_dir(q{a});


# FILENAME: 02-distshare.t
# CREATED: 29/10/11 09:36:52 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: Basic Sharedir test

done_testing;


