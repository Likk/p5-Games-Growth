use 5.40.0;
use autodie;
use utf8;
use Test2::V0;
use Test2::Tools::Spec;
use Test2::Plugin::SRand seed => time;

use Games::Growth::Model::Character::Job;

describe 'about Games::Growth::Model::Character::Job#search_generalist' => sub {
    my $hash;

    describe 'case call method' => sub {
        before_all "create receiver" => sub {
            $hash->{status} = +{
                atk => 12,
                def => 13,
                ldr => 12,
                agi => 13,
                vit => 12,
                skl => 13,
            };
        };

        it 'should return HashRef' => sub {
            my $job_status = Games::Growth::Model::Character::Job->search_generalist($hash->{status});
            is $job_status->{name}, 'バランサー', 'search_generalist name';
            is $job_status->{score}, 10,           'search_generalist score';
        };
    };

    describe 'case call method' => sub {
        before_all "create receiver" => sub {
            $hash->{status} = +{
                atk => 24,
                def => 22,
                ldr => 22,
                agi => 22,
                vit => 23,
                skl => 23,
            };
        };

        it 'should return HashRef' => sub {
            my $job_status = Games::Growth::Model::Character::Job->search_generalist($hash->{status});
            is $job_status->{name}, 'ハーモナイザー', 'search_generalist name';
            is $job_status->{score}, 20,              'search_generalist score';
        };
    };
};

done_testing;
