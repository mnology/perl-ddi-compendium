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

    has login_form => (
        isa         => 'Str',
        is          => 'ro',
        required    => 1,
        default     => 'aspnetForm',
    );

    has user_field => (
        isa         => 'Str',
        is          => 'ro',
        required    => 1,
        default     => 'ctl00$ctl00$ctl00$ctl00$SiteContent$DnDContent$ctl00$UserName',
    );

    has pass_field => (
        isa         => 'Str',
        is          => 'ro',
        required    => 1,
        default     => 'ctl00$ctl00$ctl00$ctl00$SiteContent$DnDContent$ctl00$UserPassword',
    );

    has login_button => (
        isa         => 'Str',
        is          => 'ro',
        required    => 1,
        default     => 'ctl00$ctl00$ctl00$ctl00$SiteContent$DnDContent$ctl00$LoginButton',
    );

    has user => (
        isa     => 'Str',
        is      => 'rw',
    );

    has pass => (
        isa     => 'Str',
        is      => 'rw',
    );

    has logged_in => (
        isa     => 'Bool',
        is      => 'rw',
        lazy_build => 1,
    );
    
    around cookies {
        $self->$orig($self->_build_cookies);
    }

    around logged_in {
        $self->$orig($self->_build_logged_in);
    }
 
    sub _build_cookies {
        my $self = shift;
        [ map { $_ =~ m{\:\s(.*?)\=}} split( /\n/, $self->ua->cookie_jar->as_string) ];
    }

    sub _build_logged_in {
        my $self = shift;
        return 1 if '.ASPXAUTH' ~~ $self->cookies;
        return undef;
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

    method login {
        if ( not ($self->user and $self->pass) ) {
            $self->carp('Username and Password required to login');
            return;
        }

        $self->ua->get($self->ddi_uri);

        $self->ua->form_name($self->login_form);
        $self->ua->set_fields( $self->user_field => $self->user, $self->pass_field => $self->pass );
        $self->ua->click($self->login_button) or return;
    }

    method logout {
        return 1 if not $self->logged_in;

        $self->ua->get($self->ddi_uri);
        $self->ua->click($self->login_button) or return;
    }
}

1;
