use strict;
use warnings;

package tshare;

sub module_build_version {
    require Module::Metadata;
    return Module::Metadata->new_from_module('Module::Build')->version;
}

my ( $root, $corpus, $global );

BEGIN {
    use FindBin;
    use Path::Tiny qw(path);
    $root   = path("$FindBin::Bin")->parent->absolute;
    $corpus = $root->child('corpus');
    $global = $corpus->child('global');
    $ENV{'GIT_AUTHOR_NAME'} = $ENV{'GIT_COMMITTER_NAME'} = 'Anon Y. Mus';
    $ENV{'GIT_AUTHOR_EMAIL'} = $ENV{'GIT_COMMITTER_EMAIL'} =
      'anonymus@example.org';
}

use Test::File::ShareDir 0.3.0 -share => {
    -module => {
        'Dist::Zilla::MintingProfile::Author::KENTNL' =>
          $root->child('share')->child('profiles')
    }
};

sub root   { return $root }
sub corpus { return $corpus }
sub global { 
    # this exists because dzil internals dont support Path::Tiny yet :(
    require Path::Class::Dir;
    return Path::Class::Dir->new($global)
}

use Test::DZil;

sub mk_minter {
    my ( $self, $profile ) = @_;

    require Path::Class::Dir;
    return Minter->_new_from_profile(
        [ 'Author::KENTNL'   => $profile ],
        { name               => 'DZT-Minty', },
        { global_config_root => $self->global },
    );

}

1;
