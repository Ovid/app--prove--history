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

    my $sql = <<'    END_SQL';
    INSERT INTO test (suite_id, name, mtime, result, run_time, num_todo)
    VALUES (?,?,?,?,?,?)
    END_SQL
    my $sth = $self->dbh->prepare($sql);
    foreach my $test ($self->results->tests) {
        my $name     = $test->name;
        my $mtime    = $test->mtime;
        my $result   = $test->result;
        my $run_time = $test->run_time;
        my $num_todo = $test->num_todo;
        $sth->execute($id, $name, $mtime, $result, $run_time, $num_todo);
    }
}

1;

__END__
$self = bless( {
  '_' => bless( {
    'generation' => 1,
    'tests' => {
      't/00-load.t' => bless( {
        'elapsed' => '0.119601964950562',
        'gen' => 1,
        'last_pass_time' => '1220538486.85619',
        'last_result' => 0,
        'last_run_time' => '1220538486.85619',
        'last_todo' => 0,
        'name' => 't/00-load.t',
        'seq' => 1,
        'total_passes' => 1
      }, 'App::Prove::History::State::Result::Test' ),
      't/boilerplate.t' => bless( {
        'elapsed' => '0.0304319858551025',
        'gen' => 1,
        'last_pass_time' => '1220538486.89502',
        'last_result' => 0,
        'last_run_time' => '1220538486.89502',
        'last_todo' => 0,
        'name' => 't/boilerplate.t',
        'seq' => 2,
        'total_passes' => 1
      }, 'App::Prove::History::State::Result::Test' ),
      't/builder.t' => bless( {
        'elapsed' => '0.105643033981323',
        'gen' => 1,
        'last_pass_time' => '1220538487.00787',
        'last_result' => 0,
        'last_run_time' => '1220538487.00787',
        'last_todo' => 0,
        'name' => 't/builder.t',
        'seq' => 3,
        'total_passes' => 1
      }, 'App::Prove::History::State::Result::Test' ),
      't/pod-coverage.t' => bless( {
        'elapsed' => '0.0723168849945068',
        'gen' => 1,
        'last_pass_time' => '1220538487.08755',
        'last_result' => 0,
        'last_run_time' => '1220538487.08755',
        'last_todo' => 0,
        'name' => 't/pod-coverage.t',
        'seq' => 4,
        'total_passes' => 1
      }, 'App::Prove::History::State::Result::Test' ),
      't/pod.t' => bless( {
        'elapsed' => '0.0706801414489746',
        'gen' => 1,
        'last_pass_time' => '1220538487.16538',
        'last_result' => 0,
        'last_run_time' => '1220538487.16538',
        'last_todo' => 0,
        'name' => 't/pod.t',
        'seq' => 5,
        'total_passes' => 1
      }, 'App::Prove::History::State::Result::Test' )
    },
    'version' => 1
  }, 'App::Prove::History::State::Result' ),
  'extension' => '.t',
  'select' => [],
  'seq' => 6,
  'should_save' => 1,
  'store' => '.prove'
}, 'App::Prove::History::State' );
