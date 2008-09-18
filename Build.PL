use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name       => 'App::Prove::History',
    license           => 'perl',
    dist_author       => 'Curtis "Ovid" Poe <ovid@cpan.org>',
    dist_version_from => 'lib/App/Prove/History.pm',
    requires          => {
        'Class::BuildMethods' => 0.22,
        'DateTime'            => 0.4304,
        'DBI'                 => 1.43,
        'DBD::SQLite'         => 1.14,
        'aliased'             => 0.22,
    },
    build_requires     => { 'Test::Most' => 0.11, },
    add_to_cleanup     => ['App-Prove-History-*'],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
