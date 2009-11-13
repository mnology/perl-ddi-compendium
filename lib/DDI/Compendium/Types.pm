package DDI::Compendium::Types;

use strict;
use warnings;

use MooseX::Types -declare => [qw(Class RoleName TrueFalse XMLElem XMLNode)];
use MooseX::Types::Moose qw(HashRef Int Str);
use MooseX::Types::Structured qw(Dict);

use XML::LibXML;

enum RoleName, qw(Controller Defender Leader Striker);
enum TrueFalse, qw(True False);

class_type  XMLNode, { class => 'XML::LibXML::Node' };

class_type  XMLElem, { class => 'XML::LibXML::Element' };
coerce      XMLElem,
    from Str,
    via {
        my $parser = XML::LibXML->new;
        $parser->parse_string($_)->getDocumentElement;
    };

subtype Class,
    as Dict[
        id                  => Int,
        name                => Str,
        power_source_text   => Str,
        role_name           => RoleName,
        key_abilities       => Str,
        is_new              => TrueFalse,
        is_changed          => TrueFalse,
        sourcebook          => Str,
        teaser              => Int,
    ];
coerce  Class,
    from XMLNode,
    via {
        id                  => $_->findvalue('Id'),
        name                => $_->findvalue('Name'),
        power_source_text   => $_->findvalue('PowerSourceText'),
        role_name           => $_->findvalue('RoleName'),
        key_abilities       => $_->findvalue('KeyAbilities'),
        is_new              => $_->findvalue('IsNew'),
        is_changed          => $_->findvalue('IsChanged'),
        sourcebook          => $_->findvalue('SourceBook'),
        teaser              => $_->findvalue('Teaser'),
    };

1;
