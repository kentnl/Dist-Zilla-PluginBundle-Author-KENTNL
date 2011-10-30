use 5.010000;
use strict;
use warnings;

package Dist::Zilla::Plugin::Author::KENTNL::MinimumPerl;
BEGIN {
  $Dist::Zilla::Plugin::Author::KENTNL::MinimumPerl::AUTHORITY = 'cpan:KENTNL';
}
{
  $Dist::Zilla::Plugin::Author::KENTNL::MinimumPerl::VERSION = '1.0.23';
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

sub _build_detected_perl {
  my ($self) = @_;
  my $minver;
  foreach my $file ( @{ $self->found_files } ) {

    # TODO should we scan the content for the perl shebang?
    # Only check .t and .pm/pl files, thanks RT#67355 and DOHERTY
    next unless $file->name =~ /\.(?:t|p[ml])$/i;

    # TODO skip "bad" files and not die, just warn?
    my $pmv = Perl::MinimumVersion->new( \$file->content );
    if ( !defined $pmv ) {
      $self->log_fatal( "Unable to parse '" . $file->name . "'" );
    }
    my $ver = $pmv->minimum_version;
    if ( !defined $ver ) {
      $self->log_fatal( "Unable to extract MinimumPerl from '" . $file->name . "'" );
    }
    if ( !defined $minver or $ver > $minver ) {
      $minver = $ver;
    }
    if ( $minver < version->parse('5.10.0') ) {
      my $document = $pmv->Document;
      for my $versiondecl (@{
        $document->find( 
        sub { 
            $_[1]->class eq 'PPI::Token::Quote::Single'
              and $_[1]->parent->find_any(sub{ 
                $_[1]->isa('PPI::Token::Symbol') and  $_[1]->content =~ /::VERSION$/
            })
        }) || []
      }){
        my $v = eval $versiondecl;
        if ( $v =~ /\d+\.\d+\./ and $minver < version->parse('5.10.0') ) {
          $minver = version->parse('5.10.0');
          say "Upgraded to 5.10 due to " . $file->name . " having x.y.z";
        }
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

  $self->log_debug( 'Minimum Perl is v' . $minperl );
  $self->zilla->register_prereqs( { phase => 'runtime' }, perl => $minperl->stringify, );

};

no Moose;
__PACKAGE__->meta->make_immutable;
1;


__END__
=pod

=head1 NAME

Dist::Zilla::Plugin::Author::KENTNL::MinimumPerl - The MinimumPerl Plugin with a few hacks

=head1 VERSION

version 1.0.23

=head1 AUTHOR

Kent Fredric <kentnl@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Kent Fredric.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

