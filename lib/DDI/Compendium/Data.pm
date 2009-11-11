use MooseX::Declare;

role DDI::Compendium::Data with DDI::Compendium::Filter {
    use List::MoreUtils qw(uniq);

    has tabs => (
        isa        => 'ArrayRef',
        is         => 'ro',
        lazy_build => 1,
    );

    
    # the categories to search in
    sub _build_tabs {
        my $self = shift;

        my $null_query = {
            Keywords => q{.},
            NameOnly => 'false',
            Tab      => q{},
        };

        my $query_uri = $self->keyword_uri();
        $query_uri->query_form($null_query);

        my $tot_doc = $self->get_doc($self->get_content( $query_uri ) )
            or return;

        return [ map { $_->findvalue('Table') } $tot_doc->findnodes('*/Tab') ];
    }

    
}

1;
