use MooseX::Declare;

role DDI::Compendium::Filter with (DDI::Compendium::Parser, DDI::Compendium::WWW, DDI::Compendium::URI) {
    
    use List::MoreUtils qw(uniq);

    has filters => (
        isa        => 'HashRef',
        is         => 'ro',
        lazy_build => 1,
    );

    has filter_types => (
        isa     => 'ArrayRef',
        is      => 'ro',
        default => sub {
            my $self = shift;
            return [ uniq sort map { $self->filters->{$_}->{'type'} } keys %{ $self->filters } ];
        },
    );

    sub _build_filters {
        my $self = shift;

        my $filter_content = $self->get_content( $self->filters_uri() );
        return {
            map {
                $_->findvalue('val') => {
                    'type' => $_->findvalue('type'),
                    'id'   => $_->findvalue('id'),
                    }
                } $self->get_doc($filter_content)->findnodes('Option')
        };
    }

    method filter_by_type( Str $type! ) {
        if ( not $type ~~ $self->filter_types ) {
            $self->carp("Filter Type Unknown: '$type'");
            return;
        }

        return sort grep { $_ if defined }
            map { $_ if $self->filters->{$_}->{'type'} eq $type } keys %{ $self->filters };
    }

    method translate_filter ( HashRef $filter!) {

    }

}

1;
