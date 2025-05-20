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

    describe 'case status matches single_professional' => sub {
        describe 'case match atk professional' => sub {
            before_all "setup job-list" => sub {
                $hash->{threshold_point} = [8, 18, 28, 38];
                $hash->{distance}        = [1,  2,  4,  6];
                $hash->{job_names}       = [qw/Striker Braveheart Berserker Ravager/];
                $hash->{status}          = Games::Growth::Model::Character->initial_character->{status}
            };

            it "should return atk's job" => sub {
                for my $entries (0..3){
                    my $threshold = $hash->{threshold_point}->[$entries];
                    my $distance  = $hash->{distance}->[$entries];
                    my $job_name  = $hash->{job_names}->[$entries];

                    # target status
                    $hash->{status}->{atk} = [List::Util::shuffle($threshold..$threshold + 9)]->[0];
                    # other status
                    $hash->{status}->{def} = [List::Util::shuffle(5..$threshold - $distance)]->[0];
                    $hash->{status}->{ldr} = [List::Util::shuffle(5..$threshold - $distance)]->[0];
                    $hash->{status}->{agi} = [List::Util::shuffle(5..$threshold - $distance)]->[0];
                    $hash->{status}->{vit} = [List::Util::shuffle(5..$threshold - $distance)]->[0];
                    $hash->{status}->{skl} = [List::Util::shuffle(5..$threshold - $distance)]->[0];

                    my $job              = Games::Growth::Model::Character::Job->search_job($hash->{status});
                    my $status_as_string = join(',', map { "$_:$hash->{status}->{$_}" } qw/atk def ldr agi vit skl/);
                    is $job->{name},  $job_name, sprintf("search_job name: %s => %s", $job_name, $status_as_string);
                    is $job->{score}, $threshold, 'search_job score';
                }
            };
        };

        describe 'case match def professional' => sub {
            before_all "setup and job-list" => sub {
                $hash->{threshold_point} = [8, 18, 28, 38];
                $hash->{distance}        = [1,  2,  4,  6];
                $hash->{job_names}       = [qw/Defender  Ironclad   Hoplite   Paladin/];
                $hash->{status}          = Games::Growth::Model::Character->initial_character->{status}
            };

            it "should return def's job" => sub {
                for my $entries (0..3){
                    my $threshold = $hash->{threshold_point}->[$entries];
                    my $distance  = $hash->{distance}->[$entries];
                    my $job_name  = $hash->{job_names}->[$entries];

                    # target status
                    $hash->{status}->{def} = [List::Util::shuffle($threshold..$threshold + 9)]->[0];
                    # other status
                    $hash->{status}->{atk} = [List::Util::shuffle(5..$threshold - $distance)]->[0];
                    $hash->{status}->{ldr} = [List::Util::shuffle(5..$threshold - $distance)]->[0];
                    $hash->{status}->{agi} = [List::Util::shuffle(5..$threshold - $distance)]->[0];
                    $hash->{status}->{vit} = [List::Util::shuffle(5..$threshold - $distance)]->[0];
                    $hash->{status}->{skl} = [List::Util::shuffle(5..$threshold - $distance)]->[0];

                    my $job              = Games::Growth::Model::Character::Job->search_job($hash->{status});
                    my $status_as_string = join(',', map { "$_:$hash->{status}->{$_}" } qw/atk def ldr agi vit skl/);
                    is $job->{name},  $job_name, sprintf("search_job name: %s => %s", $job_name, $status_as_string);
                    is $job->{score}, $threshold, 'search_job score';
                }
            };
        };

        describe 'case match ldr professional' => sub {
            before_all "setup and job-list" => sub {
                $hash->{threshold_point} = [8, 18, 28, 38];
                $hash->{distance}        = [1,  2,  4,  6];
                $hash->{job_names}       = [qw/Enabler   Strategist Vanguard  Resonant/];
                $hash->{status}          = Games::Growth::Model::Character->initial_character->{status}
            };

            it "should return ldr's job" => sub {
                for my $entries (0..3){
                    my $threshold = $hash->{threshold_point}->[$entries];
                    my $distance  = $hash->{distance}->[$entries];
                    my $job_name  = $hash->{job_names}->[$entries];

                    # target status
                    $hash->{status}->{ldr} = [List::Util::shuffle($threshold..$threshold + 9)]->[0];
                    # other status
                    $hash->{status}->{atk} = [List::Util::shuffle(5..$threshold - $distance)]->[0];
                    $hash->{status}->{def} = [List::Util::shuffle(5..$threshold - $distance)]->[0];
                    $hash->{status}->{agi} = [List::Util::shuffle(5..$threshold - $distance)]->[0];
                    $hash->{status}->{vit} = [List::Util::shuffle(5..$threshold - $distance)]->[0];
                    $hash->{status}->{skl} = [List::Util::shuffle(5..$threshold - $distance)]->[0];

                    my $job              = Games::Growth::Model::Character::Job->search_job($hash->{status});
                    my $status_as_string = join(',', map { "$_:$hash->{status}->{$_}" } qw/atk def ldr agi vit skl/);
                    is $job->{name},  $job_name, sprintf("search_job name: %s => %s", $job_name, $status_as_string);
                    is $job->{score}, $threshold, 'search_job score';
                }
            };
        };

        describe 'case match agi professional' => sub {
            before_all "setup and job-list" => sub {
                $hash->{threshold_point} = [8, 18, 28, 38];
                $hash->{distance}        = [1,  2,  4,  6];
                $hash->{job_names}       = [qw/Sprinter  Speedster  Phantom   Tempest/];
                $hash->{status}          = Games::Growth::Model::Character->initial_character->{status}
            };

            it "should return agi's job" => sub {
                for my $entries (0..3){
                    my $threshold = $hash->{threshold_point}->[$entries];
                    my $distance  = $hash->{distance}->[$entries];
                    my $job_name  = $hash->{job_names}->[$entries];

                    # target status
                    $hash->{status}->{agi} = [List::Util::shuffle($threshold..$threshold + 9)]->[0];
                    # other status
                    $hash->{status}->{atk} = [List::Util::shuffle(5..$threshold - $distance)]->[0];
                    $hash->{status}->{def} = [List::Util::shuffle(5..$threshold - $distance)]->[0];
                    $hash->{status}->{ldr} = [List::Util::shuffle(5..$threshold - $distance)]->[0];
                    $hash->{status}->{vit} = [List::Util::shuffle(5..$threshold - $distance)]->[0];
                    $hash->{status}->{skl} = [List::Util::shuffle(5..$threshold - $distance)]->[0];

                    my $job              = Games::Growth::Model::Character::Job->search_job($hash->{status});
                    my $status_as_string = join(',', map { "$_:$hash->{status}->{$_}" } qw/atk def ldr agi vit skl/);
                    is $job->{name},  $job_name, sprintf("search_job name: %s => %s", $job_name, $status_as_string);
                    is $job->{score}, $threshold, 'search_job score';
                }
            };
        };

        describe 'case match vit professional' => sub {
            before_all "setup and job-list" => sub {
                $hash->{threshold_point} = [8, 18, 28, 38];
                $hash->{distance}        = [1,  2,  4,  6];
                $hash->{job_names}       = [qw/Fighter   Warrior    Viking    Guardian/];
                $hash->{status}          = Games::Growth::Model::Character->initial_character->{status}
            };

            it "should return vit's job" => sub {
                for my $entries (0..3){
                    my $threshold = $hash->{threshold_point}->[$entries];
                    my $distance  = $hash->{distance}->[$entries];
                    my $job_name  = $hash->{job_names}->[$entries];

                    # target status
                    $hash->{status}->{vit} = [List::Util::shuffle($threshold..$threshold + 9)]->[0];
                    # other status
                    $hash->{status}->{atk} = [List::Util::shuffle(5..$threshold - $distance)]->[0];
                    $hash->{status}->{def} = [List::Util::shuffle(5..$threshold - $distance)]->[0];
                    $hash->{status}->{ldr} = [List::Util::shuffle(5..$threshold - $distance)]->[0];
                    $hash->{status}->{agi} = [List::Util::shuffle(5..$threshold - $distance)]->[0];
                    $hash->{status}->{skl} = [List::Util::shuffle(5..$threshold - $distance)]->[0];

                    my $job              = Games::Growth::Model::Character::Job->search_job($hash->{status});
                    my $status_as_string = join(',', map { "$_:$hash->{status}->{$_}" } qw/atk def ldr agi vit skl/);
                    is $job->{name},  $job_name, sprintf("search_job name: %s => %s", $job_name, $status_as_string);
                    is $job->{score}, $threshold, 'search_job score';
                }
            };
        };

        describe 'case match skl professional' => sub {
            before_all "setup and job-list" => sub {
                $hash->{threshold_point} = [8, 18, 28, 38];
                $hash->{distance}        = [1,  2,  4,  6];
                $hash->{job_names}       = [qw/Duelist   Assassin   Slayer    Executor/];
                $hash->{status}          = Games::Growth::Model::Character->initial_character->{status}
            };

            it "should return skl's job" => sub {
                for my $entries (0..3){
                    my $threshold = $hash->{threshold_point}->[$entries];
                    my $distance  = $hash->{distance}->[$entries];
                    my $job_name  = $hash->{job_names}->[$entries];

                    # target status
                    $hash->{status}->{skl} = [List::Util::shuffle($threshold..$threshold + 9)]->[0];
                    # other status
                    $hash->{status}->{atk} = [List::Util::shuffle(5..$threshold - $distance)]->[0];
                    $hash->{status}->{def} = [List::Util::shuffle(5..$threshold - $distance)]->[0];
                    $hash->{status}->{ldr} = [List::Util::shuffle(5..$threshold - $distance)]->[0];
                    $hash->{status}->{agi} = [List::Util::shuffle(5..$threshold - $distance)]->[0];
                    $hash->{status}->{vit} = [List::Util::shuffle(5..$threshold - $distance)]->[0];

                    my $job              = Games::Growth::Model::Character::Job->search_job($hash->{status});
                    my $status_as_string = join(',', map { "$_:$hash->{status}->{$_}" } qw/atk def ldr agi vit skl/);
                    is $job->{name},  $job_name, sprintf("search_job name: %s => %s", $job_name, $status_as_string);
                    is $job->{score}, $threshold, 'search_job score';
                }
            };
        };
    };
};

done_testing;
