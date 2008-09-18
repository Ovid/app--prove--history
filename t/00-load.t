#!perl -T

use Test::Most 'bail';

BEGIN {
    my @modules = qw(
        App::Prove::History
        App::Prove::History::Builder
        App::Prove::History::State
        App::Prove::History::State::Result
        App::Prove::History::State::Result::Test
    );
    plan tests => scalar @modules;
    foreach my $module (@modules) {
        use_ok $module;
    }
}

diag( "Testing App::Prove::History $App::Prove::History::VERSION, Perl $], $^X" );
