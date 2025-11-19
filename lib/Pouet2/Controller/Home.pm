package Pouet2::Controller::Home;

use 5.022;
use warnings;

use base 'Mojolicious::Controller';

use utf8;


sub _read_book {
	my $self = shift;
	my $file = shift;
	
	my (@file, @book);
	my $fh;
	open $fh, '<:encoding(utf8)', $file;
	@file = <$fh>;
	close $fh;

	
	my $c = 0;
	my @buff;
	for my $s (@file) {
		$s =~ s/\s+$//g;
		$c ++ unless $s;
		
		push @buff, $s;
		
		if ($c >= 4) {
			if (!$s) {
				my ($i, $j);
				for (0..scalar (@buff)-1) {
					if ($buff[$_]) {
						$i = $_;
						last;
					}
				}
				
				for (1..scalar (@buff)) {
					
					if ($buff[scalar (@buff) - $_] ) {
						$j = scalar (@buff) - $_;
						last;
					} 
				}
				
				
				if ($i || $j) {
				
					my @b2;
					for ($i..$j) {
						push @b2, $buff[$_];
					}
					
					if (scalar (@b2) >= 2) {
						my $p = join "\n", @b2;

						if ($p =~ /\S/) {
							push @book, $p;	
						}
					
						@buff = ();
						
					}
				}

			}
			$c = 0;
		} 
	}

	return \@book;
}

sub _pouem_base {
	my $self = shift;
	state $base;
	unless ($base) {
		$base = [];
		my $dh;
		
		opendir $dh, './books';
		while (my $f = readdir $dh) {
			if (-f './books/' . $f && $f =~ /\.txt$/) {
				my $book = $self->_read_book('./books/' . $f);
				push @$base, @$book;
			}
		}
		closedir $dh;
	}
	
	return $base;
}

sub get_pouem {
	my $self = shift;
	my $base = $self->_pouem_base;
	return $base->[int rand (scalar @$base)];
}


sub home {
	my $self = shift;
	
	my $p = $self->get_pouem();

	$self->render(pouem => $p);
}

1;
