#!/usr/bin/env perl

use strict;
use warnings;

use DBI;
use Test::Most qw/no_plan die/;

my $test_db = 't/tmp/test.db';
my $dbh =
  DBI->connect( "dbi:SQLite:dbname=$test_db", '', '', { RaiseError => 1 }, );

END {
#   unlink $test_db or warn "Could not unlink ($test_db): $!";
}

use App::Prove::History::Builder;
my $class = 'App::Prove::History::Builder';
can_ok $class, 'new';
isa_ok my $builder = $class->new( { dbh => $dbh } ), $class,
  '... and the object it returns';

can_ok $builder, 'build';
ok $builder->build, '... and calling it should succeed';

lives_ok {  $dbh->selectall_arrayref('SELECT * FROM suite') }
    '... and the "suite" table should be created';
