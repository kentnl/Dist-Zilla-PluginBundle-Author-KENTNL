use 5.006;    # our
use strict;
use warnings;

package Dist::Zilla::MintingProfile::Author::KENTNL;

# ABSTRACT: KENTNL's Minting Profile

our $VERSION = '2.025003';

# AUTHORITY

use Moose qw( with );
use namespace::autoclean;
with 'Dist::Zilla::Role::MintingProfile::ShareDir';

=encoding UTF-8

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Dist::Zilla::MintingProfile::Author::KENTNL",
    "inherits":"Moose::Object",
    "does":"Dist::Zilla::Role::MintingProfile::ShareDir",
    "interface":"class"
}

=end MetaPOD::JSON

=cut

__PACKAGE__->meta->make_immutable;
no Moose;
1;

=head1 SYNOPSIS

    dzil new -P Author::KENTNL Some::Dist::Name

=cut
