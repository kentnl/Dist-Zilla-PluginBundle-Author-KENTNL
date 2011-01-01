use strict;
use warnings;

package Dist::Zilla::MintingProfile::Author::KENTNL;

# ABSTRACT: KENTNL's Minting Profile

use Moose;
use namespace::autoclean;
with 'Dist::Zilla::Role::MintingProfile::ShareDir';

=head1 SYNOPSIS

    dzil new -P Author::KENTNL Some::Dist::Name

=cut

__PACKAGE__->meta->make_immutable;
no Moose;
1;
