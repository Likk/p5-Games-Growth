use 5.40.0;
use autodie;
use utf8;
use Test2::V0;
use Test2::Tools::Spec;
use Test2::Plugin::SRand seed => time;

use Games::Growth::Model::Character::Job;

describe 'about Games::Growth::Model::Character::Job#search_single_professional' => sub {
    my $hash;

    describe 'case call method' => sub {
        before_all "create receiver" => sub {
            $hash->{status} = +{
                atk => 38,
                def => 32,
                ldr => 31,
                agi => 29,
                vit => 21,
                skl => 20,
            };
        };

        it 'should return HashRef' => sub {
            my $job_status = Games::Growth::Model::Character::Job->search_single_professional($hash->{status});
            is $job_status->{name}, 'ブレイカー', 'search_single_professional name';
            is $job_status->{score}, 38,          'search_single_professional score';
        };
    };

    describe 'case call method' => sub {
        before_all "create receiver" => sub {
            $hash->{status} = +{
                atk => 26,
                def => 28,
                ldr => 25,
                agi => 20,
                vit => 18,
                skl => 21,
            };
        };

        it 'should return HashRef' => sub {
            my $job_status = Games::Growth::Model::Character::Job->search_single_professional($hash->{status});
            is $job_status->{name}, 'ホプロマクス', 'search_single_professional name';
            is $job_status->{score}, 28,            'search_single_professional score';
        };
    };

    describe 'case call method' => sub {
        before_all "create receiver" => sub {
            $hash->{status} = +{
                atk => 15,
                def => 11,
                ldr => 15,
                agi => 16,
                vit => 18,
                skl => 16,
            };
        };

        it 'should return HashRef' => sub {
            my   $job_status = Games::Growth::Model::Character::Job->search_single_professional($hash->{status});
            is   $job_status->{score}, 18,           'search_single_professional score';
            like $job_status->{name},  'ウォーリア', 'search_single_professional name';
        };
    };

    describe 'case call method' => sub {
        before_all "create receiver" => sub {
            $hash->{status} = +{
                atk => 8,
                def => 8,
                ldr => 8,
                agi => 9,
                vit => 8,
                skl => 8,
            };
        };

        it 'should return HashRef' => sub {
            my   $job_status = Games::Growth::Model::Character::Job->search_single_professional($hash->{status});
            is   $job_status->{score}, 8,                                                                           'search_single_professional score';
            like $job_status->{name},  qr/スプリンター/, 'search_single_professional name';
        };
    };
};

done_testing;
