#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

package depsdiff;

use JSON;
use Data::Dump qw( pp );
use Path::Tiny qw( path );
use Data::Difference qw( data_diff );
use CPAN::Meta::Converter;

use Class::Tiny qw(json_a json_b), {
  cache      => sub { return {} },
  transcoder => sub { return JSON->new() },
  data_a     => sub {
    my ($self) = @_;
    my $result = $self->transcoder->decode( $self->json_a );
    return $result;
  },
  data_b => sub {
    my ($self) = @_;
    my $result = $self->transcoder->decode( $self->json_b );
    return $result;
  },
  prereqs_a => sub {
    my ($self) = @_;
    return $self->_get_prereqs( $self->data_a );
  },
  prereqs_b => sub {
    my ($self) = @_;
    return $self->_get_prereqs( $self->data_b );
  },
};

sub _get_prereqs {
  my ( $self, $stash ) = @_;
  my $c = CPAN::Meta::Converter->new($stash);
  my $co = $c->convert( version => 2 );
  return $co->{prereqs};
}

sub get_type {
  if ( not exists $_[0]->{b} and exists $_[0]->{a} ) {
    return 'removed';
  }
  if ( exists $_[0]->{b} and not exists $_[0]->{a} ) {
    return 'added';
  }
  if ( exists $_[0]->{b} and exists $_[0]->{a} ) {
    return 'changed';
  }
  die "Unhandled combination";
}

sub get_phase {
  return $_[0]->{path}->[0] . ' ' . $_[0]->{path}->[1];
}

sub get_module {
  return $_[0]->{path}->[2];
}

sub cache_key {
  my ( $type, $phase ) = @_;
  return 'Dependencies::' . ucfirst($type) . ' / ' . $phase;
}

sub add_dep {
  my ( $self, $phase, $module, $version ) = @_;
  my $cache_key = cache_key( 'Added', $phase );
  my $dep_cache = ( $self->cache->{$cache_key} ||= [] );
  if ( $version eq '0' ) {
    push @{$dep_cache}, $module;
    return;
  }
  push @{$dep_cache}, $module . ' ' . $version;
  return;
}

sub remove_dep {
  my ( $self, $phase, $module, $version ) = @_;
  my $cache_key = cache_key( 'Removed', $phase );
  my $dep_cache = ( $self->cache->{$cache_key} ||= [] );
  if ( $version eq '0' ) {
    push @{$dep_cache}, $module;
    return;
  }
  push @{$dep_cache}, $module . ' ' . $version;
  return;
}

sub change_dep {
  my ( $self, $phase, $module, $old_version, $new_version ) = @_;
  my $cache_key = cache_key( 'Changed', $phase );
  my $dep_cache = ( $self->cache->{$cache_key} ||= [] );
  push @{$dep_cache}, $module . ' ' . $old_version . chr(0xA0) . chr(0x2192) . chr(0xA0) . $new_version;
}

sub cache_change {
  my ( $self, $type, $path, $remove, $add ) = @_;
  if ( $type eq 'added' ) {
    return $self->add_dep( $path->[0] . ' ' . $path->[1], $path->[2], $add );
  }
  if ( $type eq 'removed' ) {
    return $self->remove_dep( $path->[0] . ' ' . $path->[1], $path->[2], $remove );
  }
  if ( $type eq 'changed' ) {
    return $self->change_dep( $path->[0] . ' ' . $path->[1], $path->[2], $remove, $add );
  }
  die "unknown type $type";
}

sub change_rel {
  my ( $self, $type, $path, $remove, $add ) = @_;
  if ( $type eq 'added' ) {

    for my $key ( sort keys %{$add} ) {
      my $new_path = [ @{$path}, $key ];
      $self->cache_change( $type, $new_path, undef, $add->{$key} );
    }
    return;
  }
  if ( $type eq 'removed' ) {
    for my $key ( sort keys %{$remove} ) {
      my $new_path = [ @{$path}, $key ];
      $self->cache_change( $type, $new_path, $remove->{$key}, undef );
    }
    return;
  }

  die "Unhandled change_rel $type";
}

sub change_phase {
  my ( $self, $type, $path, $remove, $add ) = @_;
  if ( $type eq 'added' ) {

    for my $key ( sort keys %{$add} ) {
      my $new_path = [ @{$path}, $key ];
      $self->change_rel( $type, $new_path, undef, $add->{$key} );
    }
    return;
  }
  if ( $type eq 'removed' ) {
    for my $key ( sort keys %{$remove} ) {
      my $new_path = [ @{$path}, $key ];
      $self->change_rel( $type, $new_path, $remove->{$key}, undef );
    }
    return;
  }
  die "Unhandled change_phase $type";
}

sub execute {
  my ($self) = @_;

  for my $d ( data_diff( $self->prereqs_a, $self->prereqs_b ) ) {
    my $type = get_type($d);
    if ( scalar @{ $d->{path} } == 3 ) {
      $self->cache_change( $type, $d->{path}, $d->{a}, $d->{b} );
      next;
    }
    if ( scalar @{ $d->{path} } == 2 ) {
      $self->change_rel( $type, $d->{path}, $d->{a}, $d->{b} );
      next;
    }
    if ( scalar @{ $d->{path} } == 1 ) {
      $self->change_phase( $type, $d->{path}, $d->{a}, $d->{b} );
      next;
    }
    warn "Path not a known length";
    next;
  }

}
1;
