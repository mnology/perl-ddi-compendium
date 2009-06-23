#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'DDI::Compendium' );
}

diag( "Testing DDI::Compendium $DDI::Compendium::VERSION, Perl $], $^X" );
