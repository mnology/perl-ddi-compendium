package DDI::Compendium::Types;

use strict;
use warnings;

use MooseX::Types -declare => [ qw( XMLElem ) ];
use MooseX::Types::Moose qw( Str );

use XML::LibXML;

class_type XMLElem, { class => 'XML::LibXML::Element' };

coerce XMLElem,
    from Str,
    via {
        my $parser = XML::LibXML->new;
        $parser->parse_string($_)->getDocumentElement;
    };

1;
