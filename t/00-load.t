#!perl -T

use Test::Most 'bail';
use lib 'lib';

BEGIN {
    my @modules = qw(
        App::Prove::History
        App::Prove::History::Builder
        App::Prove::History::State
    );
    plan tests => scalar @modules;
    foreach my $module (@modules) {
        use_ok $module;
    }
}

diag( "Testing App::Prove::History $App::Prove::History::VERSION, Perl $], $^X" );
