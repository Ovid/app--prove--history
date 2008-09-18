package App::Prove::History;

use warnings;
use strict;
use Getopt::Long;
use Carp 'croak';
use App::Prove::History::State;

=head1 NAME

App::Prove::History - Track test suite changes over time.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';
use base 'App::Prove';

use constant STATE_DB => __PACKAGE__->IS_UNIXY ? '.provedb'   : '_provedb';

=head1 SYNOPSIS

    use App::Prove::History;

    my $app = App::Prove::History->new;
    $app->process_args(@ARGV);
    $app->run;
    exit($app->exit_status);   # if you care about exit status

=cut

sub _initialize {
    my $self = shift;
    $self->{db} = STATE_DB;
    $self->SUPER::_initialize(@_);
}

sub db {
    my $self = shift;
    return $self->{db} unless @_;
    $self->{db} = shift;
    return $self;
}

sub process_args {
    my ( $self, @args ) = @_;
    for my $i ( 0 .. $#args ) {
        local $_ = $args[$i];
        if ( /\A--db(?:=(.*))?\z/ ) {
            if ( defined $1 ) {
                $self->db($1);
                splice @args, $i, 1;
            }
            else {
                $self->db($args[$i+1]);
                splice @args, $i, 2;
                unless ( defined $self->db) {
                    croak("No database defined for '--db' argument");
                }
            }
            last;
        }
    }
    $self->SUPER::process_args(@args);
}

sub exit_status {
    my $self = shift;
    return $self->{exit} unless @_;
    $self->{exit} = shift;
    return $self;
}

sub run {
    my $self = shift;
    $self->exit_status($self->SUPER::run ? 0 : 1);
    return $self;
}

sub state_class {
    'App::Prove::History::State';
}

=head1 AUTHOR

Curtis "Ovid" Poe, C<< <ovid at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-app-prove-state-history at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=App-Prove-History>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc App::Prove::History


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=App-Prove-History>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/App-Prove-History>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/App-Prove-History>

=item * Search CPAN

L<http://search.cpan.org/dist/App-Prove-History>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2008 Curtis "Ovid" Poe, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of App::Prove::History