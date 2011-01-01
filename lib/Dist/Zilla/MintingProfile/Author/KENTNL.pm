use strict;
use warnings;

package Dist::Zilla::MintingProfile::Author::KENTNL;

# ABSTRACT: KENTNL's Minting Profile
use Moose;
use namespace::autoclean;
with 'Dist::Zilla::Role::MintingProfile::ShareDir';

__PACKAGE__->meta->make_immutable;
1;
