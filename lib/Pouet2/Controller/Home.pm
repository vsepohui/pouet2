package Pouet2::Controller::Home;

use 5.022;
use warnings;

use base 'Mojolicious::Controller';


sub home {
	my $self = shift;

	$self->render();
}

1;
