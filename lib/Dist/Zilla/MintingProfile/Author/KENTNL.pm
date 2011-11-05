use strict;
use warnings;

package Dist::Zilla::MintingProfile::Author::KENTNL;
BEGIN {
  $Dist::Zilla::MintingProfile::Author::KENTNL::AUTHORITY = 'cpan:KENTNL';
}
{
  $Dist::Zilla::MintingProfile::Author::KENTNL::VERSION = '1.2.0';
}

# ABSTRACT: KENTNL's Minting Profile

use Moose;
use namespace::autoclean;
with 'Dist::Zilla::Role::MintingProfile::ShareDir';


__PACKAGE__->meta->make_immutable;
no Moose;
1;

__END__
=pod

=encoding utf-8

=head1 NAME

Dist::Zilla::MintingProfile::Author::KENTNL - KENTNL's Minting Profile

=head1 VERSION

version 1.2.0

=head1 SYNOPSIS

    dzil new -P Author::KENTNL Some::Dist::Name

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Kent Fredric.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

