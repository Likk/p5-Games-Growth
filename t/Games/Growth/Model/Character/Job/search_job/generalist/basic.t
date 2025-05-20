use 5.40.0;
use autodie;
use utf8;

use List::Util;

use Test2::V0;
use Test2::Tools::Spec;
use Test2::Plugin::SRand seed => time;

use Games::Growth::Model::Character;
use Games::Growth::Model::Character::Job;

describe 'about Games::Growth::Model::Character::Job#search_job' => sub {
    my $hash;

    describe 'case status matches generalist' => sub {
        before_all "setup job-list" => sub {
            $hash->{threshold_point} = [10, 20, 30, 40];
            $hash->{distance}        = [3,   5,  5,  5];
            $hash->{job_names}       = [qw/Balancer Harmonizer Polymath Hero/];
            $hash->{status}          = Games::Growth::Model::Character->initial_character->{status}
        };

        it "should return balancer's job" => sub {
            for my $entries (0..3){
                my $threshold = $hash->{threshold_point}->[$entries];
                my $distance  = $hash->{distance}->[$entries];
                my $job_name  = $hash->{job_names}->[$entries];

                do {
                    $hash->{status}->{atk} = [List::Util::shuffle($threshold..$threshold+$distance)]->[0];
                    $hash->{status}->{def} = [List::Util::shuffle($threshold..$threshold+$distance)]->[0];
                    $hash->{status}->{ldr} = [List::Util::shuffle($threshold..$threshold+$distance)]->[0];
                    $hash->{status}->{agi} = [List::Util::shuffle($threshold..$threshold+$distance)]->[0];
                    $hash->{status}->{vit} = [List::Util::shuffle($threshold..$threshold+$distance)]->[0];
                    $hash->{status}->{skl} = [List::Util::shuffle($threshold..$threshold+$distance)]->[0];
                    # redo if status match dual_profession
                    scalar(grep { $_ >= $threshold + 2 } values %{$hash->{status}}) >= 2 and redo;
                };

                my $job              = Games::Growth::Model::Character::Job->search_job($hash->{status});
                my $status_as_string = join(',', map { "$_:$hash->{status}->{$_}" } qw/atk def ldr agi vit skl/);
                is $job->{name},  $job_name, sprintf("search_job name: %s => %s", $job_name, $status_as_string);
                is $job->{score}, $threshold, 'search_job score';
            }
        };
    };
};

done_testing;
