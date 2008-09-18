package App::Prove::History::State;

use strict;
use warnings;
use App::Prove::History::State::Result;

use base 'App::Prove::State';

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);
}

sub _dbh {
    my $self = shift;
    return $self->{dbh} unless @_;
    $self->{dbh} = shift;
    return $self;
}

sub result_class {
    return 'App::Prove::History::State::Result';
}

sub save {
    my $self = shift;

use Data::Dumper::Simple;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Sortkeys = 1;
    print STDERR Dumper($self);
    $self->SUPER::save;
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