use 5.006;    # our
use strict;
use warnings;

package inc::CPANFile::Merged;

# ABSTRACT: Like CPANFile, but with merging control

# AUTHORITY

use Moose qw( extends );
use Safe::Isa qw( $_isa );
extends "Dist::Zilla::Plugin::CPANFile";
no Moose;
__PACKAGE__->meta->make_immutable;

sub _split_dep {
  return @{ $_[0] || [] } if ref $_[0];
  return split /\./, $_[0], 2;
}

# ->steal_requirements( C:M:R )
sub CPAN::Meta::Requirements::steal_requirements {
  my ( $self, $other ) = @_;
  my $copy = $other->clone;
  for my $module ( $other->required_modules ) {
    $other->clear_requirement($module);
  }
  $self->add_requirements($copy);
}

# ->fold_requirements( ['runtime','requires'] => [['runtime','suggests']] )
sub CPAN::Meta::Prereqs::fold_requirements {
  my ( $self, $to, $froms ) = @_;
  my $target = $self->requirements_for( _split_dep($to) );
  for my $from_target ( @{ $froms || [] } ) {
    $target->steal_requirements( $self->requirements_for( _split_dep($from_target) ) );
  }
}

sub _merged_prereqs {
  my ($self) = @_;
  my $target = $self->zilla->prereqs->cpan_meta_prereqs->clone;
  for my $phase (qw( runtime develop configure test build )) {
    $target->fold_requirements( "$phase.requires" => [ "$phase.recommends", "$phase.suggests", ] );
  }
  return $target;
}

sub gather_files {
  my ( $self, $arg ) = @_;

  my $file = Dist::Zilla::File::FromCode->new(
    {
      name => $self->filename,
      code => sub {
        my $prereqs = $self->_merged_prereqs;

        my @types  = qw(requires recommends suggests conflicts);
        my @phases = qw(runtime build test configure develop);

        my $str = '';
        for my $phase (@phases) {
          for my $type (@types) {
            my $req = $prereqs->requirements_for( $phase, $type );
            next unless $req->required_modules;
            $str .= qq[\non '$phase' => sub {\n] unless $phase eq 'runtime';
            $str .= $self->_hunkify_hunky_hunk_hunks( ( $phase eq 'runtime' ? 0 : 1 ), $type, $req, );
            $str .= qq[};\n] unless $phase eq 'runtime';
          }
        }

        return $str;
      },
    }
  );

  $self->add_file($file);
  return;
}

1;

