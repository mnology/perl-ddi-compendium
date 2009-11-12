use MooseX::Declare;

role DDI::Compendium::WWW {
    use WWW::Mechanize;
    use MooseX::Types::URI qw( Uri );

    has ua => (
        isa      => 'WWW::Mechanize',
        is       => 'rw',
        required => 1,
        default  => sub { WWW::Mechanize->new() },
    );

    method get_content ( Uri $uri! ) {
        $self->ua->get( $uri )->content();
    }

    method query_content ( HashRef $query! ) {
        my $q_form = $self->keyword_uri->clone;
        $q_form->query_form($query);

        $self->get_content( $q_form );
    }
}

1;
