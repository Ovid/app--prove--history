package App::Prove::History::Builder;

use strict;
use warnings;

=head1 NAME

App::Prove::History::Builder

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';

=head1 SYNOPSIS

    use App::Prove::History::Builder;

    my $builder = App::Prove::History::Builder->new( { dbh => $dbh } );
    $builder->build;

=head1 DESCRIPTION

This class builds the test database.  It's for internal use only, but the
least I can do is document the schema for you.

=head1 SCHEMA

All tables have a single non-identifying id cleverly named C<id>.  As SQLite
doesn't support foreign keys (though this can be simulated with triggers), we
adopt the convention that another table's reference to a table should be in a
field named C<${table}_id>.  For example, anything referencing the C<suite>
table would have a field named C<suite_id> and this should match C<suite.id>.

=cut

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

=head2 C<suite>

    CREATE TABLE IF NOT EXISTS suite (
        id         INTEGER PRIMARY KEY,
        version    REAL     NOT NULL,
        start_time DATETIME NOT NULL,
        end_time   DATETIME NOT NULL
    );

=over 4

=item * C<version> 

C<App::Prove::State::History> version.

=item * C<state_time>

When the test suite started.

=item * C<end_time>

When the test suite ended.

=item * C<notes>

Used to store additional free-form notes, if needed.  We have it here, but
don't yet have the interface ready for it.

=back

=cut

sub _sql_suite_table {
    return <<'    END_SQL';
    CREATE TABLE IF NOT EXISTS suite (
        id         INTEGER PRIMARY KEY,
        version    REAL     NOT NULL,
        start_time DATETIME NOT NULL,
        end_time   DATETIME NOT NULL,
        notes      BLOB
    );
    END_SQL
}

=head2 C<test_result>

    CREATE TABLE IF NOT EXISTS test_result (
        id           INTEGER PRIMARY KEY,
        suite_id     INTEGER NOT NULL,
        test_name_id INTEGER NOT NULL,
        passed       INTEGER NOT NULL,
        failed       INTEGER NOT NULL,
        todo         INTEGER NOT NULL,
        todo_passed  INTEGER NOT NULL,
        skipped      INTEGER NOT NULL,
        planned      INTEGER NOT NULL,
        tests_run    INTEGER NOT NULL,
        exit         INTEGER NOT NULL,
        wait         INTEGER NOT NULL,
        run_time     REAL    NOT NULL
    );

=over 4

=item * C<suite_id>

A reference to C<suite.id>

=item * C<test_name_id>

A reference to C<test_name.id>

=item * C<passed>

The number of tests which passed.

=item * C<failed>

The number of tests which failed.

=item * C<todo>

The number of TODO tests.

=item * C<todo_passed>

The number of TODO tests which unexpectedly succeeded.

=item * C<skipped>

The number of tests skipped.

=item * C<planned>

The number of tests planned.

=item * C<tests_run>

The number of tests run.

=item * C<exit>

The exit status of the test.

=item * C<wait>

The wait status of the test.

=item * C<run_time>

The time in seconds it tooks the test program to run.  If L<Time::HiRes> is
installed, it will have a high resolution time.

=back

=cut

sub _sql_test_result_table {
    return <<'    END_SQL';
    CREATE TABLE IF NOT EXISTS test_result (
        id           INTEGER PRIMARY KEY,
        suite_id     INTEGER NOT NULL,
        test_name_id INTEGER NOT NULL,
        passed       INTEGER NOT NULL,
        failed       INTEGER NOT NULL,
        todo         INTEGER NOT NULL,
        todo_passed  INTEGER NOT NULL,
        skipped      INTEGER NOT NULL,
        planned      INTEGER NOT NULL,
        tests_run    INTEGER NOT NULL,
        exit         INTEGER NOT NULL,
        wait         INTEGER NOT NULL,
        run_time     REAL    NOT NULL
    );
    END_SQL
}

=head2 C<test_name>

    CREATE TABLE IF NOT EXISTS test_name (
        id   INTEGER PRIMARY KEY,
        name VARCHAR(255) NOT NULL
    );

=over 4

=item * C<name>

The name of the test (typically a filename).

Note that this doesn't match xUnit conventions.  Maybe we'll change this.

=back

=cut

sub _sql_test_name_table {
    return <<'    END_SQL';
    CREATE TABLE IF NOT EXISTS test_name (
        id   INTEGER PRIMARY KEY,
        name VARCHAR(255) NOT NULL
    );
    END_SQL
}

1;
