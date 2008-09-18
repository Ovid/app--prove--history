package App::Prove::History::Builder;

use strict;
use warnings;

sub new {
    my ( $class, $arg_for ) = @_;
    my $self = bless {
        dbh => $arg_for->{dbh},
    } => $class;
    return $self;
}

sub _dbh { shift->{dbh} }

sub build {
    my $self = shift;

    my $dbh = $self->_dbh;
    $dbh->do($self->_sql_suite_table);
    return $self;
}

sub _sql_suite_table {
    return <<'    END_SQL';
    CREATE TABLE IF NOT EXISTS suite (
        id         INTEGER PRIMARY KEY,
        start_time DATETIME NOT NULL,
        end_time   DATETIME NOT NULL
    );
    END_SQL
}

1;
