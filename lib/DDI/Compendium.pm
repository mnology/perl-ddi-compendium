use MooseX::Declare;

=head1 NAME

DDI::Compendium - The great new DDI::Compendium!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use DDI::Compendium;

    my $foo = DDI::Compendium->new();
    ...

=cut

class DDI::Compendium {
    use List::MoreUtils qw(true uniq);
    use Carp qw(carp);

    use URI;
    use WWW::Mechanize;
    use XML::LibXML;

    # API URI attribute construction
    has base_uri => (
        isa      => 'Str',
        is       => 'ro',
        required => 1,
        default =>
          'http://www.wizards.com/dndinsider/compendium/CompendiumSearch.asmx/',
    );

    my %uri_attrs = (
        filters_uri       => 'GetFilterSelect',
        keyword_uri       => 'KeywordSearch',
        filter_search_uri => 'KeywordSearchWithFilters',
        all_uri           => 'ViewAll',
    );

    while ( my ( $attr, $oper ) = each %uri_attrs ) {
        has $attr => (
            isa      => 'URI',
            is       => 'ro',
            lazy     => 1,
            required => 1,
            default  => sub {
                my $self = shift;
                URI->new( $self->base_uri() . $oper );
            },
        );
    }

    has ua => (
        isa      => 'WWW::Mechanize',
        is       => 'rw',
        required => 1,
        default  => sub { WWW::Mechanize->new() },
    );

    has parser => (
        isa      => 'XML::LibXML',
        is       => 'ro',
        required => 1,
        default  => sub { XML::LibXML->new(); }
    );

    has tabs => (
        isa        => 'ArrayRef',
        is         => 'ro',
        lazy_build => 1,
    );

    sub _build_tabs {
        my $self = shift;

        my $null_query = {
            Keywords => q{.},
            Tab      => q{},
        };

        my $query_uri = $self->keyword_uri();
        $query_uri->query_form($null_query);

        my $content = $self->ua->get($query_uri)->content();
        my $tot_doc = $self->parser->parse_string($content)->getDocumentElement()
          or return;

        return [ map { $_->findvalue('Table') } $tot_doc->findnodes('*/Tab') ];
    }

    has filters_doc => (
        isa      => 'XML::LibXML::Document',
        is       => 'rw',
        lazy     => 1,
        required => 1,
        default  => sub {
            my $self = shift;
            $self->parser->parse_string( $self->ua->get( $self->filters_uri() )->content() );
        }
    );

    has filter_types => (
        isa        => 'ArrayRef',
        is         => 'ro',
        lazy_build => 1,
    );

    sub _build_filter_types {
        my $self = shift;
        [ uniq map { $_->findvalue('type') }
              $self->filters_doc->getDocumentElement->findnodes('Option') ];
    }

    has filter_data => (
        isa        => 'HashRef',
        is         => 'rw',
        lazy_build => 1,
    );

    sub _build_filter_data {
        my $self = shift;

        my $doc_elem = $self->filters_doc->getDocumentElement;
        return {
            map {
                $_->findvalue('type') => { 
                     $_->findvalue('val') => $_->findvalue('id'),
                  }
              }
              map { $doc_elem->findnodes("Option[type = '$_']") } @{ $self->filter_types() }
        };
    }

    has filter_search_categories => (
        isa        => 'ArrayRef',
        is         => 'ro',
        lazy_build => 1,
    );

    sub _build_filter_search_categories {

        my $self = shift;

        return [
            uniq grep { $_ if defined }
              map { $self->filter_data->{$_}->{type} if $self->filter_data->{$_}->{id} != 0 }
              keys %{ $self->filter_data }
        ];
    }

    method view_all_doc( Str $tab ) {

        if ( not true { $tab eq $_ } @{ $self->tabs() } ) {
            $self->carp("Tab Unknown: '$tab'");
            return;
        }

        my $all_query = { Tab => $tab, };
          my $query_uri = $self->all_uri();

          $query_uri->query_form($all_query);
          my $content = $self->ua->get($query_uri)->content;

          return $self->parser->parse_string($content);
      }

      method filters_by_type( Str $type ) {

        if ( not true { $type eq $_ } @{ $self->filter_types() } ) {
            $self->carp("Type Unknown: '$type'");
            return;
        }

        return grep { $_ if $self->filter_data->{$_}->{type} eq $type }
          keys %{ $self->filter_data }
      }

}

=head1 AUTHOR

Erik Johansen, C<< <mnology at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-ddi-compendium at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=DDI-Compendium>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc DDI::Compendium


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=DDI-Compendium>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/DDI-Compendium>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/DDI-Compendium>

=item * Search CPAN

L<http://search.cpan.org/dist/DDI-Compendium>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Erik Johansen, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1;    # End of DDI::Compendium
