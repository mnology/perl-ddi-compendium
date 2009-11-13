use MooseX::Declare;

role DDI::Compendium::Parser {
    use DDI::Compendium::Types qw (Class XMLElem);

    method get_doc ( XMLElem $doc! does coerce ){
        return $doc;
    }

    # passing in full query args to preserve options for recursive calling
    method parse_search ( HashRef $query! ) {
        my $doc = $self->get_doc( $self->query_content($query) );

        my @result_tabs = $self->tabs_with_results( $doc );

        #my $parse_tabs = {  map{} @{$self->tabs} };
    }

    method tabs_with_results ( XMLElem $doc! ) {
        return map { $_->textContent } $doc->findnodes('//Totals/Tab[Total != 0]/Table');
    }

    method tab_coerce (Str $tab!){
        if (not $tab ~~ $self->tabs) {
            $self->carp("Unknown Tab '$tab'");
            return;
        }
    }

    method parse_class ( Class $elem! does coerce ) {
        
    }
    method parse_deity {}
    method parse_epicdestiny{}
    method parse_feat {}
    method parse_glossary {}
    method parse_item{}
    method parse_monster {}
    method parse_paragonpath {}
    method parse_power {}
    method parse_race {}
    method parse_ritual {}
    method parse_skill {}
    method parse_trap {}
}

#map { my $sub = 'parse_' . lc($_); $_ => \&$sub }
#
1;
