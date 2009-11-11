use MooseX::Declare;

role DDI::Compendium::WWW {
  use WWW::Mechanize;

  has ua => (
        isa      => 'WWW::Mechanize',
        is       => 'rw',
        required => 1,
        default  => sub { WWW::Mechanize->new() },
    );

    method get_content ( URI $uri! ) {
        $self->ua->get( $uri )->content();
    }
}

1;
