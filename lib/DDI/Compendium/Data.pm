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

        my $tot_doc = $self->get_doc($self->query_content($null_query))
            or return;

        return [ sort map { $_->findvalue('Table') } $tot_doc->findnodes('*/Tab') ];
    }

    
}

1;
