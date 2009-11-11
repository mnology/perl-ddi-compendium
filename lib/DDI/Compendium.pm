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

class DDI::Compendium with DDI::Compendium::Data {
    use Carp qw(carp);

    

    method view_all_doc( Str $tab! ) {

        if ( not $tab ~~ @{ $self->tabs() } ) {
            $self->carp("Tab Unknown: '$tab'");
            return;
        }

        my $all_query = { Tab => $tab, };
            my $query_uri = $self->all_uri();

            $query_uri->query_form($all_query);
            my $content = $self->ua->get($query_uri)->content;

            return $self->parser->parse_string($content);
      }

      method keyword_search( ArrayRef[Str] $keywords!, Str $tab?, Bool $name_only?, HashRef $filter? ) {
        if ( $tab and not $tab ~~ @{ $self->tabs } ) {
            $self->carp("Tab Unknown: '$tab'");
            return;
        }

        my $query_uri = defined $filter ? $self->filter_search_uri() : $self->keyword_uri();

        my $keyword_query = {
            Keywords => join( q{ }, @$keywords ),
            NameOnly => ( defined $name_only and $name_only == 1 ) ? 'true' : 'false',
            Tab => defined $tab ? $tab : q{},
        };

        $keyword_query->{Filters} = xlate_filter($filter) if $filter;
        $query_uri->query_form($keyword_query);

        # make a parse_results which will handle cases for each type of /total
        return parse_search( $self->ua->get($query_uri)->content );
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
