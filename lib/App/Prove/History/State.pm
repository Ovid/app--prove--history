package App::Prove::History::State;

use strict;
use warnings;

use DateTime;
use Class::BuildMethods qw/
    dbh
    builder
    start_time
    end_time
/;

use aliased 'App::Prove::History::State::Result';
use aliased 'App::Prove::History::Builder';

use base 'App::Prove::State';

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);
    $self->start_time(DateTime->now);
}

sub result_class {
    return Result;
}

sub save {
    my $self = shift;

use Data::Dumper::Simple;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Sortkeys = 1;
    print STDERR Dumper($self);
    $self->builder->build;
    $self->end_time(DateTime->now);
#    $self->SUPER::save(@_);
    $self->_save_state;
}

sub _save_state {
    my $self = shift;
    my $sql = <<'    END_SQL';
    INSERT INTO suite (version, start_time, end_time)
    VALUES (?, ?, ?)
    END_SQL
    $self->dbh->do(
        $sql, 
        {}, 
        $App::Prove::History::VERSION,
        $self->start_time, 
        $self->end_time
    );
    my $id = $self->dbh->last_insert_id(undef, undef, 'suite', 'id');
    $self->_save_tests($id);
    $self->dbh->commit;
}

sub _save_tests {
    my ( $self, $id ) = @_;

    my $dbh = $self->dbh;
    my $name_sth = $dbh->prepare(<<'    END_SQL');
    INSERT INTO test_name (name) VALUES (?)
    END_SQL

    my $id_for = $dbh->selectall_hashref(<<'    END_SQL', 'name');
    SELECT id, name FROM test_name
    END_SQL

    my $result_sth = $dbh->prepare(<<'    END_SQL');
    INSERT INTO test_result (suite_id, name_id, mtime, result, run_time, num_todo)
    VALUES (?,?,?,?,?,?)
    END_SQL
    foreach my $test ($self->results->tests) {
        my $name     = $test->name;
        my $mtime    = $test->mtime;
        my $result   = $test->result;
        my $run_time = $test->run_time;
        my $num_todo = $test->num_todo;

        my $name_id = $id_for->{$name}{id} || $self->_test_name_id($name);

        $result_sth->execute( 
            $id, 
            $name_id, 
            $mtime, 
            $result, 
            $run_time,
            $num_todo,
        );
    }
}

sub _test_name_id {
    my ( $self, $name ) = @_;
    $self->dbh->do('INSERT INTO test_name (name) VALUES (?)', {}, $name);
    return $self->dbh->last_insert_id(undef, undef, 'test_name', 'id');
}

1;
