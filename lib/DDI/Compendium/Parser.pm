use MooseX::Declare;

role DDI::Compendium::Parser {
    use DDI::Compendium::Types qw ( XMLDoc );

    method get_doc ( XMLDoc $doc does coerce ){
        return $doc->getDocumentElement();
    }

}

1;
