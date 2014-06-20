#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

package depsdiff;

use JSON;
use Data::Dump qw( pp );
use Path::Tiny qw( path );
use CPAN::Meta;
use CPAN::Meta::Prereqs::Diff;

use Class::Tiny qw(json_a json_b),{
  differ => sub {
    my ($self) = @_;
    return CPAN::Meta::Prereqs::Diff->new(
      old_prereqs => CPAN::Meta->load_json_string( $self->json_a ),
      new_prereqs => CPAN::Meta->load_json_string( $self->json_b ),
    );
  },
};

sub _get_prereqs {
  my ( $self, $stash ) = @_;
  my $c = CPAN::Meta::Converter->new($stash);
  my $co = $c->convert( version => 2 );
  return $co->{prereqs};
}

sub changes {
  my ($self) = @_;
  return $self->differ->diff(
    phases => [qw( configure build runtime test develop )],
    types  => [qw( requires recommends suggests conflicts )],
  );
}
1;
