use strict;
use warnings;

package Dist::Zilla::Plugin::Author::KENTNL::MinimumPerl;
BEGIN {
  $Dist::Zilla::Plugin::Author::KENTNL::MinimumPerl::AUTHORITY = 'cpan:KENTNL';
}
{
  $Dist::Zilla::Plugin::Author::KENTNL::MinimumPerl::VERSION = '1.4.1';
}

# FILENAME: MinimumPerl.pm
# CREATED: 31/10/11 05:25:54 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: The MinimumPerl Plugin with a few hacks

use Moose;
extends 'Dist::Zilla::Plugin::MinimumPerl';
use namespace::autoclean;

has 'detected_perl' => (
  is         => 'rw',
  isa        => 'Object',
  lazy_build => 1,
);

has 'fiveten' => (
  isa     => 'Bool',
  is      => 'rw',
  default => sub { undef },
);

sub _3part_check {
  my ( $self, $file, $pmv, $minver ) = @_;
  my $perl_required = version->parse('5.10.0');
  return $minver if $minver >= $perl_required;
  my $document            = $pmv->Document;
  my $version_declaration = sub {
    $_[1]->isa('PPI::Token::Symbol') and $_[1]->content =~ /::VERSION\z/msx;
  };
  my $version_match = sub {
    $_[1]->class eq 'PPI::Token::Quote::Single' and $_[1]->parent->find_any($version_declaration);
  };
  my (@versions) = @{ $document->find($version_match) || [] };
  for my $versiondecl (@versions) {
    next
      if $minver >= $perl_required;
    ## no critic (ProhibitStringyEval)
    my $v = eval $versiondecl;
    if ( $v =~ /\A\d+[.]\d+[.]/msx ) {
      $minver = $perl_required;
      $self->log_debug( [ 'Upgraded to %s due to %s having x.y.z', $minver, $file->name ] );
    }
  }
  return $minver;
}

sub _build_detected_perl {
  my ($self) = @_;
  my $minver;

  foreach my $file ( @{ $self->found_files } ) {

    # TODO should we scan the content for the perl shebang?
    # Only check .t and .pm/pl files, thanks RT#67355 and DOHERTY
    next unless $file->name =~ /[.](?:t|p[ml])\z/imsx;

    # TODO skip "bad" files and not die, just warn?
    my $pmv = Perl::MinimumVersion->new( \$file->content );
    if ( not defined $pmv ) {
      $self->log_fatal( [ 'Unable to parse \'%s\'', $file->name ] );
    }
    my $ver = $pmv->minimum_version;
    if ( not defined $ver ) {
      $self->log_fatal( [ 'Unable to extract MinimumPerl from \'%s\'', $file->name ] );
    }
    if ( ( not defined $minver ) or $ver > $minver ) {
      $self->log_debug( [ 'Increasing perl dep to %s due to %s', $ver, $file->name ] );
      $minver = $ver;
    }
    if ( $self->fiveten ) {
      $ver = $self->_3part_check( $file, $pmv, $minver );
      if ( "$ver" ne "$minver" ) {
        $self->log_debug( [ 'Increasing perl dep to %s due to 3-part in %s', $ver, $file->name ] );
        $minver = $ver;
      }
    }
  }

  # Write out the minimum perl found
  if ( defined $minver ) {
    return $minver;
  }
  return $self->log_fatal('Found no perl files, check your dist?');
}


sub minperl {
  require version;
  my $self = shift;
  if ( not $self->_has_perl ) {
    return $self->detected_perl;
  }
  my ($x) = version->parse( $self->perl );
  my ($y) = $self->detected_perl;
  if ( $x > $y ) {
    return $x;
  }
  return $y;
}

override register_prereqs => sub {
  my ( $self, @args ) = @_;

  my $minperl = $self->minperl;

  $self->log_debug( [ 'Minimum Perl is v%s', $minperl ] );
  $self->zilla->register_prereqs( { phase => 'runtime' }, perl => $minperl->stringify, );

};

no Moose;
__PACKAGE__->meta->make_immutable;
1;


__END__
=pod

=encoding utf-8

=head1 NAME

Dist::Zilla::Plugin::Author::KENTNL::MinimumPerl - The MinimumPerl Plugin with a few hacks

=head1 VERSION

version 1.4.1

=head1 METHODS

=head2 C<minperl>

Returns the maximum of either the version requested for Perl, or the version detected for Perl.

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Kent Fredric.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

