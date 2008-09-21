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
    $dbh->do($self->_sql_test_result_table);
    $dbh->do($self->_sql_test_name_table);
    return $self;
}

sub _sql_suite_table {
    return <<'    END_SQL';
    CREATE TABLE IF NOT EXISTS suite (
        id         INTEGER PRIMARY KEY,
        version    REAL     NOT NULL,
        start_time DATETIME NOT NULL,
        end_time   DATETIME NOT NULL
    );
    END_SQL
}

sub _sql_test_result_table {
    return <<'    END_SQL';
    CREATE TABLE IF NOT EXISTS test_result (
        id        INTEGER PRIMARY KEY,
        suite_id  INTEGER NOT NULL,
        name_id   INTEGER NOT NULL,
        mtime     REAL NULL,
        result    INT NOT NULL,
        run_time  REAL NOT NULL,
        num_todo  INT NOT NULL
    );
    END_SQL
}

sub _sql_test_name_table {
    return <<'    END_SQL';
    CREATE TABLE IF NOT EXISTS test_name (
        id   INTEGER PRIMARY KEY,
        name VARCHAR(255) NOT NULL
    );
    END_SQL
}

1;
