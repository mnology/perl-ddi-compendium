use MooseX::Declare;

role DDI::Compendium::WWW {
    use WWW::Mechanize;
    use MooseX::Types::URI qw( Uri );

    has ua => (
        isa      => 'WWW::Mechanize',
        is       => 'rw',
        required => 1,
        default  => sub { WWW::Mechanize->new(agent => 'DDI::Compendium Perl API')  },
    );

    has cookies => (
        isa => 'ArrayRef',
        is  => 'rw',
        lazy_build => 1,
    );

    around cookies {
        $self->$orig($self->_build_cookies);
    }


    method get_content ( Uri $uri! ) {
        $self->ua->get( $uri )->content();
    }

    method all_content ( Str $tab! ) {
        if ( not $tab ~~ $self->tabs ) {
            $self->carp("Unknown Tab '$tab'");
            return;
        }

        my $all_query = { Tab => $tab, };

        my $a_form = $self->all_uri->clone;
        $a_form->query_form($all_query);

        $self->get_content($a_form);
    }

    method query_content ( HashRef $query! ) {
        my $q_form = $self->keyword_uri->clone;
        $q_form->query_form($query);

        $self->get_content($q_form);
    }

    }

1;
