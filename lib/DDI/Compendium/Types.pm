package DDI::Compendium::Types;

use strict;
use warnings;

use MooseX::Types -declare => [ qw( XMLDoc ) ];
use MooseX::Types::Moose qw( Str );

use XML::LibXML;

class_type XMLDoc, { class => 'XML::LibXML::Document' };

coerce XMLDoc,
    from Str,
    via {
        my $parser = XML::LibXML->new;
        $parser->parse_string($_)
    };

1;
