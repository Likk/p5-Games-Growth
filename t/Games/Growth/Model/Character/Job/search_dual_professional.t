use 5.40.0;
use autodie;
use utf8;
use Test2::V0;
use Test2::Tools::Spec;
use Test2::Plugin::SRand seed => time;

use Games::Growth::Model::Character::Job;

describe 'about Games::Growth::Model::Character::Job#search_dual_professional' => sub {
    my $hash;

    describe 'case call method' => sub {
        before_all "create receiver" => sub {
            $hash->{status} = +{
                atk => 42,
                def => 38,
                ldr => 38,
                agi => 38,
                vit => 38,
                skl => 42,
            };
        };

        it 'should return HashRef' => sub {
            my $job_status = Games::Growth::Model::Character::Job->search_dual_professional($hash->{status});
            is $job_status->{name}, 'Swordmaster', 'search_dual_professional name';
            is $job_status->{score}, 42,           'search_dual_professional score';
        };
    };

    describe 'case call method' => sub {
        before_all "create receiver" => sub {
            $hash->{status} = +{
                atk => 18,
                def => 18,
                ldr => 18,
                agi => 18,
                vit => 22,
                skl => 22,
            };
        };

        it 'should return HashRef' => sub {
            my $job_status = Games::Growth::Model::Character::Job->search_dual_professional($hash->{status});
            is $job_status->{name}, 'Counter', 'search_dual_professional name';
            is $job_status->{score}, 22,       'search_dual_professional score';
        };
    };

    describe 'case call method' => sub {
        before_all "create receiver" => sub {
            $hash->{status} = +{
                atk => 15,
                def => 12,
                ldr => 13,
                agi => 15,
                vit => 13,
                skl => 13,
            };
        };

        it 'should return HashRef' => sub {
            my $job_status = Games::Growth::Model::Character::Job->search_dual_professional($hash->{status});
            is $job_status->{score}, 12,       'search_dual_professional score';
            is $job_status->{name},  'Archer', 'search_dual_professional name';
        };
    };
};

done_testing;
