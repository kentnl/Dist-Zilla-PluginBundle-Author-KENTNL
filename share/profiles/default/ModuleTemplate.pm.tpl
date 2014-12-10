use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package {{ $name }};

our $VERSION = '0.001000';

# ABSTRACT: Kent Failed To Provide An Abstract

# AUTHORITY

use Moose;

__PACKAGE__->meta->make_immutable;
no Moose;

1;
