use MooseX::Declare;

role DDI::Compendium::URI {
    use MooseX::Types::URI qw( Uri );

    has api_uri => (
        isa         => Uri,
        is          => 'ro',
        required    => 1,
        coerce      => 1,
        lazy        => 1,
        default     =>'http://www.wizards.com/dndinsider/compendium/CompendiumSearch.asmx/',
    );

    has ddi_uri => (
        isa         => Uri,
        is          => 'ro',
        required    => 1,
        coerce      => 1,
        lazy        => 1,
        default     => 'http://www.wizards.com/dnd/Default.aspx',
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
            isa      => Uri,
            is       => 'ro',
            lazy     => 1,
            required => 1,
            coerce   => 1,
            default  => sub {
                my $self = shift;
                $self->get_oper_uri( $oper );
            },
        );
    }

    method get_oper_uri ( Str $oper! ) {
        $self->api_uri() . $oper;
    }

}

1;
