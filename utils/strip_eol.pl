#!/usr/bin/env perl
use strict;
use warnings;
use utf8;

use Path::Iterator::Rule;
use Path::FindDev qw( find_dev );
use Path::Tiny qw( path );

my $rule = Path::Iterator::Rule->new();

$rule->skip_vcs;
$rule->skip_dirs( qr/^.build$/, qr/^[A-Z].*[0-9]+(-TRIAL)?/ );
$rule->file->nonempty;
$rule->file->not_binary;
$rule->file->line_match(qr/\s\n/);

my $next = $rule->iter(
  find_dev('./'),
  {
    follow_symlinks => 0,
    sorted          => 0,
  }
);

while ( my $file = $next->() ) {
  my $path = path($file);
  system 'sed', '-i', 's/\s*$//', "$path";
}
