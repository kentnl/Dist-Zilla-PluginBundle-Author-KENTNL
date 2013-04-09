#!/usr/bin/env perl 

use strict;
use warnings;
use utf8;

if( @ARGV != 2 ) {
    warn "Expected: delta_deps OLD.JSON NEW.JSON";
}

use JSON;
use Data::Dump qw( pp );
use Path::Tiny qw( path );
use Data::Difference qw( data_diff );

my $transcoder = JSON->new();
my $left = $transcoder->decode( path( $ARGV[0] )->slurp );
my $right = $transcoder->decode( path( $ARGV[1] )->slurp );

my $lp = $left->{prereqs};
my $rp = $right->{prereqs};


sub get_type {
    if ( not exists $_[0]->{b} and exists $_[0]->{a} ){ 
        return 'removed';
    }
    if ( exists $_[0]->{b} and not exists $_[0]->{a} ){ 
        return 'added';
    }
    if ( exists $_[0]->{b} and  exists $_[0]->{a} ){
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

my $cache;

for my $d ( data_diff( $lp, $rp )) {
    my $type = get_type($d);
    my $cache_url = 'Dependencies::' . ucfirst( $type ) . ' / ' . get_phase($d);
    my $lcache = ( $cache->{$cache_url} ||= [] );
    if ( $type eq 'added' or $type eq 'removed' ) { 
        my $version;
        $version = $d->{a} if exists $d->{a};
        $version = $d->{b} if exists $d->{b};

        my $line = get_module( $d );
        if( $version != 0 ) { 
            $line .= ' ' . $version;
        }
        push @{$lcache}, $line;
        next;
    }
    if ( $type eq 'changed' ) { 
        my $line = get_module( $d ) . ' ' . $d->{a} . chr(0xA0) . chr(0x2192) . chr(0xA0) . $d->{b};
        push @{$lcache}, $line;
        next;
    }
}

binmode(*STDOUT,':utf8');

for my $key ( sort keys %{$cache} ) {
    print ' [' . $key . ']';
    print qq[\n];
    for my $entry ( @{ $cache->{$key} } ){
        print ' - ' . $entry . qq[\n];
    }
}

