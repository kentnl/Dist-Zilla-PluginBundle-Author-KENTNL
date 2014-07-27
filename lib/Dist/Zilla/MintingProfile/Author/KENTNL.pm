use 5.008;    # utf8 pragma
use strict;
use warnings;
use utf8;

package Dist::Zilla::MintingProfile::Author::KENTNL;

# ABSTRACT: KENTNL's Minting Profile

our $VERSION = '2.016006';

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

=head1 SYNOPSIS

    dzil new -P Author::KENTNL Some::Dist::Name

=cut

__PACKAGE__->meta->make_immutable;
no Moose;
1;
