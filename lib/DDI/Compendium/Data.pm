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

    method names_from_tab ( Str $tab ) {
        if ( not $tab ~~ $self->tabs ) {
            $self->carp("Unknown Tab '$tab'");
            return;
        }

        my $tab_doc = $self->get_doc($self->all_content($tab));

        uniq sort map { $_->textContent } $tab_doc->findnodes("//Data/Results/$tab/Name");
    }
    
}

1;
