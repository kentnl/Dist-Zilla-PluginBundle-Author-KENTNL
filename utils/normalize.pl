#!/usr/bin/perl

use strict;
use warnings;

use CPAN::Changes;

open my $fh, '>', 'Changes.out' or die "Can't open output file Changes.out, $? $! $@";

my $string = CPAN::Changes->load( 'Changes', next_token => qr{{{\$NEXT}}} )->serialize;

$string =~ s/\h*$//gms;

print {$fh} $string;

system 'diff', '-Naur', 'Changes', 'Changes.out';

