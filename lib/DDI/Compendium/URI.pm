use MooseX::Declare;

role DDI::Compendium::URI {
    use URI;

    has base_uri => (
        isa      => 'Str',
        is       => 'ro',
        required => 1,
        default =>
            'http://www.wizards.com/dndinsider/compendium/CompendiumSearch.asmx/',
    );

    # attrs for each available search URI
    my %uri_attrs = (
        filters_uri       => 'GetFilterSelect',
        keyword_uri       => 'KeywordSearch',
        filter_search_uri => 'KeywordSearchWithFilters',
        all_uri           => 'ViewAll',
    );

    while ( my ( $attr, $oper ) = each %uri_attrs ) {
        has $attr => (
            isa      => URI,
            is       => 'ro',
            lazy     => 1,
            required => 1,
            default  => sub {
                my $self = shift;
                $self->get_oper_uri( $oper );
            },
        );
    }

    method get_oper_uri ( Str $oper! ) {
        URI->new( $self->base_uri() . $oper );
    }

}

1;
