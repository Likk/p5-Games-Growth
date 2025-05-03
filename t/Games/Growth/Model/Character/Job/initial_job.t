use 5.40.0;
use utf8;
use Test2::V0;
use Test2::Tools::Spec;

use Games::Growth::Model::Character::Job;

describe 'Games::Growth::Model::Character::Job#initial_job' => sub {
    my $hash;

    describe 'case not change to INITIAL_JOB' => sub {
        it 'should return the default initial job' => sub {
            my $job = Games::Growth::Model::Character::Job->initial_job();
            is $job, hash {
                field 'name'  => match(qr/\A.+\z/);
                field 'score' => match(qr/\A[0-9]+\z/);
            }, 'initial_job initialized as expected';
        };
    };

    describe 'case change to INITIAL_JOB' => sub {
        before_all "update INITIAL_JOB" => sub {
            $hash->{INITIAL_JOB} = $Games::Growth::Model::Character::Job::INITIAL_JOB = {
                name  => 'Adventurer',
                score => 5,
            };
        };
        after_all "reset INITIAL_JOB" => sub {
            undef $hash->{INITIAL_JOB};
        };

        it 'should reflect changes to INITIAL_JOB' => sub {
            local $Games::Growth::Model::Character::Job::INITIAL_JOB = {
                name  => 'Adventurer',
                score => 5,
            };

            my $job = Games::Growth::Model::Character::Job->initial_job();
            is $job, hash {
                field 'name'  => 'Adventurer';
                field 'score' => 5;
                end;
            }, 'returns updated initial job';
        };
    };
};

done_testing;
