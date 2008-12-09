package App::Prove::History::State;

use strict;
use warnings;

=head1 NAME

App::Prove::History::State

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';

=head1 SYNOPSIS

    use App::Prove::History::State;

    my $state = App::Prove::History::State->new;
    $state->dbh($dbh);
    $state->save;

=head1 DESCRIPTION

This class saves the results of the test suite run.  Much of its behavior is
inherited from C<App::Prove::State>.  For internal use only.

=cut

use DateTime;
use Class::BuildMethods qw/
    dbh
    builder
    start_time
    end_time
/;

use aliased 'App::Prove::History::Builder';

use base 'App::Prove::State';

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);
    $self->start_time(DateTime->now);
    return $self;
}

# overriding parent method
sub commit { shift->save }

sub save {
    my $self = shift;

    $self->builder->build;
    $self->end_time(DateTime->now);
    $self->SUPER::save;
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
    INSERT INTO test_result (
        suite_id, 
        test_name_id,
        passed,
        failed,
        todo,
        todo_passed,
        skipped,
        planned,
        tests_run,
        exit,
        wait,
        run_time
    )
    VALUES (?,?,?,?,?,?,?,?,?,?,?,?)
    END_SQL
    foreach my $test ( $self->results->tests ) {

        # XXX woo hoo!  We now have a parser method here.  It will be better
        # than these annoying things.  Requires the svn version of
        # Test::Harness.
        my $parser = $test->parser;
        my $name   = $test->name;

        my $passed      = $parser->passed;
        my $failed      = $parser->failed;
        my $todo        = $parser->todo;
        my $todo_passed = $parser->todo_passed;
        my $skipped     = $parser->skipped;
        my $planned     = $parser->tests_planned;
        my $tests_run   = $parser->tests_run;
        my $exit        = $parser->exit;
        my $wait        = $parser->wait;
        my $run_time    = $test->run_time;

        my $name_id = $id_for->{$name}{id} || $self->_test_name_id($name);

        $result_sth->execute(
            $id,        $name_id,     $passed,  $failed,
            $todo,      $todo_passed, $skipped, $planned,
            $tests_run, $exit,        $wait,    $run_time,
          )
    }
}

sub _test_name_id {
    my ( $self, $name ) = @_;
    $self->dbh->do('INSERT INTO test_name (name) VALUES (?)', {}, $name);
    return $self->dbh->last_insert_id(undef, undef, 'test_name', 'id');
}

1;
