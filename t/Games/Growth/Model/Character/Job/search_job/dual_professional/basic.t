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

    describe 'case status matches dual_professional' => sub {
        describe 'case match atk and def professional' => sub {
            before_all "setup job-list" => sub {
                $hash->{threshold_point} = [12, 22, 42];
                $hash->{distance}        = [2,   3,  4];
                $hash->{job_names}       = [qw/Brawler   Crusher     Destroyer/];
                $hash->{status}          = Games::Growth::Model::Character->initial_character->{status}
            };

            it "should return atk-def job" => sub {
                for my $entries (0..2){
                    my $threshold = $hash->{threshold_point}->[$entries];
                    my $distance  = $hash->{distance}->[$entries];
                    my $job_name  = $hash->{job_names}->[$entries];

                    # target status
                    $hash->{status}->{atk} = [List::Util::shuffle($threshold..$threshold + 5)]->[0];
                    $hash->{status}->{def} = [List::Util::shuffle($threshold..$threshold + 5)]->[0];
                    # other status
                    $hash->{status}->{ldr} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{agi} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{vit} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{skl} = [List::Util::shuffle(9..$threshold - $distance)]->[0];

                    my $job              = Games::Growth::Model::Character::Job->search_job($hash->{status});
                    my $status_as_string = join(',', map { "$_:$hash->{status}->{$_}" } qw/atk def ldr agi vit skl/);
                    is $job->{name},  $job_name, sprintf("search_job name: %s => %s", $job_name, $status_as_string);
                    is $job->{score}, $threshold, 'search_job score';
                }
            };
        };

        describe 'case match atk and ldr professional' => sub {
            before_all "setup job-list" => sub {
                $hash->{threshold_point} = [12, 22, 42];
                $hash->{distance}        = [2,   3,  4];
                $hash->{job_names}       = [qw/Striker   Smasher     Vanquisher/];
                $hash->{status}          = Games::Growth::Model::Character->initial_character->{status}
            };

            it "should return atk-ldr job" => sub {
                for my $entries (0..2){
                    my $threshold = $hash->{threshold_point}->[$entries];
                    my $distance  = $hash->{distance}->[$entries];
                    my $job_name  = $hash->{job_names}->[$entries];

                    # target status
                    $hash->{status}->{atk} = [List::Util::shuffle($threshold..$threshold + 5)]->[0];
                    $hash->{status}->{ldr} = [List::Util::shuffle($threshold..$threshold + 5)]->[0];
                    # other status
                    $hash->{status}->{def} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{agi} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{vit} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{skl} = [List::Util::shuffle(9..$threshold - $distance)]->[0];

                    my $job              = Games::Growth::Model::Character::Job->search_job($hash->{status});
                    my $status_as_string = join(',', map { "$_:$hash->{status}->{$_}" } qw/atk def ldr agi vit skl/);
                    is $job->{name},  $job_name, sprintf("search_job name: %s => %s", $job_name, $status_as_string);
                    is $job->{score}, $threshold, 'search_job score';
                }
            };
        };

        describe 'case match atk and agi professional' => sub {
            before_all "setup job-list" => sub {
                $hash->{threshold_point} = [12, 22, 42];
                $hash->{distance}        = [2,   3,  4];
                $hash->{job_names}       = [qw/Archer    Hunter      Sniper/];
                $hash->{status}          = Games::Growth::Model::Character->initial_character->{status}
            };

            it "should return atk-agi job" => sub {
                for my $entries (0..2){
                    my $threshold = $hash->{threshold_point}->[$entries];
                    my $distance  = $hash->{distance}->[$entries];
                    my $job_name  = $hash->{job_names}->[$entries];

                    # target status
                    $hash->{status}->{atk} = [List::Util::shuffle($threshold..$threshold + 5)]->[0];
                    $hash->{status}->{agi} = [List::Util::shuffle($threshold..$threshold + 5)]->[0];
                    # other status
                    $hash->{status}->{def} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{ldr} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{vit} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{skl} = [List::Util::shuffle(9..$threshold - $distance)]->[0];

                    my $job              = Games::Growth::Model::Character::Job->search_job($hash->{status});
                    my $status_as_string = join(',', map { "$_:$hash->{status}->{$_}" } qw/atk def ldr agi vit skl/);
                    is $job->{name},  $job_name, sprintf("search_job name: %s => %s", $job_name, $status_as_string);
                    is $job->{score}, $threshold, 'search_job score';
                }
            };
        };

        describe 'case match atk and vit professional' => sub {
            before_all "setup job-list" => sub {
                $hash->{threshold_point} = [12, 22, 42];
                $hash->{distance}        = [2,   3,  4];
                $hash->{job_names}       = [qw/Burster    Skirmisher  Rampager/];
                $hash->{status}          = Games::Growth::Model::Character->initial_character->{status}
            };

            it "should return atk-vit job" => sub {
                for my $entries (0..2){
                    my $threshold = $hash->{threshold_point}->[$entries];
                    my $distance  = $hash->{distance}->[$entries];
                    my $job_name  = $hash->{job_names}->[$entries];

                    # target status
                    $hash->{status}->{atk} = [List::Util::shuffle($threshold..$threshold + 5)]->[0];
                    $hash->{status}->{vit} = [List::Util::shuffle($threshold..$threshold + 5)]->[0];
                    # other status
                    $hash->{status}->{def} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{ldr} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{agi} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{skl} = [List::Util::shuffle(9..$threshold - $distance)]->[0];

                    my $job              = Games::Growth::Model::Character::Job->search_job($hash->{status});
                    my $status_as_string = join(',', map { "$_:$hash->{status}->{$_}" } qw/atk def ldr agi vit skl/);
                    is $job->{name},  $job_name, sprintf("search_job name: %s => %s", $job_name, $status_as_string);
                    is $job->{score}, $threshold, 'search_job score';
                }
            };
        };

        describe 'case match atk and skl professional' => sub {
            before_all "setup job-list" => sub {
                $hash->{threshold_point} = [12, 22, 42];
                $hash->{distance}        = [2,   3,  4];
                $hash->{job_names}       = [qw/Gladiator Champion    Swordmaster/];
                $hash->{status}          = Games::Growth::Model::Character->initial_character->{status}
            };

            it "should return atk-skl job" => sub {
                for my $entries (0..2){
                    my $threshold = $hash->{threshold_point}->[$entries];
                    my $distance  = $hash->{distance}->[$entries];
                    my $job_name  = $hash->{job_names}->[$entries];

                    # target status
                    $hash->{status}->{atk} = [List::Util::shuffle($threshold..$threshold + 5)]->[0];
                    $hash->{status}->{skl} = [List::Util::shuffle($threshold..$threshold + 5)]->[0];
                    # other status
                    $hash->{status}->{def} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{ldr} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{agi} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{vit} = [List::Util::shuffle(9..$threshold - $distance)]->[0];

                    my $job              = Games::Growth::Model::Character::Job->search_job($hash->{status});
                    my $status_as_string = join(',', map { "$_:$hash->{status}->{$_}" } qw/atk def ldr agi vit skl/);
                    is $job->{name},  $job_name, sprintf("search_job name: %s => %s", $job_name, $status_as_string);
                    is $job->{score}, $threshold, 'search_job score';
                }
            };
        };

        describe 'case match def and ldr professional' => sub {
            before_all "setup job-list" => sub {
                $hash->{threshold_point} = [12, 22, 42];
                $hash->{distance}        = [2,   3,  4];
                $hash->{job_names}       = [qw/Shooter    Sweeper     Sentinel/];
                $hash->{status}          = Games::Growth::Model::Character->initial_character->{status}
            };

            it "should return def-ldr job" => sub {
                for my $entries (0..2){
                    my $threshold = $hash->{threshold_point}->[$entries];
                    my $distance  = $hash->{distance}->[$entries];
                    my $job_name  = $hash->{job_names}->[$entries];

                    # target status
                    $hash->{status}->{def} = [List::Util::shuffle($threshold..$threshold + 5)]->[0];
                    $hash->{status}->{ldr} = [List::Util::shuffle($threshold..$threshold + 5)]->[0];
                    # other status
                    $hash->{status}->{atk} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{agi} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{vit} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{skl} = [List::Util::shuffle(9..$threshold - $distance)]->[0];

                    my $job              = Games::Growth::Model::Character::Job->search_job($hash->{status});
                    my $status_as_string = join(',', map { "$_:$hash->{status}->{$_}" } qw/atk def ldr agi vit skl/);
                    is $job->{name},  $job_name, sprintf("search_job name: %s => %s", $job_name, $status_as_string);
                    is $job->{score}, $threshold, 'search_job score';
                }
            };
        };

        describe 'case match def and agi professional' => sub {
            before_all "setup job-list" => sub {
                $hash->{threshold_point} = [12, 22, 42];
                $hash->{distance}        = [2,   3,  4];
                $hash->{job_names}       = [qw/Stormer    Interceptor Juggernaut/];
                $hash->{status}          = Games::Growth::Model::Character->initial_character->{status}
            };

            it "should return def-agi job" => sub {
                for my $entries (0..2){
                    my $threshold = $hash->{threshold_point}->[$entries];
                    my $distance  = $hash->{distance}->[$entries];
                    my $job_name  = $hash->{job_names}->[$entries];

                    # target status
                    $hash->{status}->{def} = [List::Util::shuffle($threshold..$threshold + 5)]->[0];
                    $hash->{status}->{agi} = [List::Util::shuffle($threshold..$threshold + 5)]->[0];
                    # other status
                    $hash->{status}->{atk} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{ldr} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{vit} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{skl} = [List::Util::shuffle(9..$threshold - $distance)]->[0];

                    my $job              = Games::Growth::Model::Character::Job->search_job($hash->{status});
                    my $status_as_string = join(',', map { "$_:$hash->{status}->{$_}" } qw/atk def ldr agi vit skl/);
                    is $job->{name},  $job_name, sprintf("search_job name: %s => %s", $job_name, $status_as_string);
                    is $job->{score}, $threshold, 'search_job score';
                }
            };
        };

        describe 'case match def and vit professional' => sub {
            before_all "setup job-list" => sub {
                $hash->{threshold_point} = [12, 22, 42];
                $hash->{distance}        = [2,   3,  4];
                $hash->{job_names}       = [qw/Tank       Fortress    Aegis/];
                $hash->{status}          = Games::Growth::Model::Character->initial_character->{status}
            };

            it "should return def-vit job" => sub {
                for my $entries (0..2){
                    my $threshold = $hash->{threshold_point}->[$entries];
                    my $distance  = $hash->{distance}->[$entries];
                    my $job_name  = $hash->{job_names}->[$entries];

                    # target status
                    $hash->{status}->{def} = [List::Util::shuffle($threshold..$threshold + 5)]->[0];
                    $hash->{status}->{vit} = [List::Util::shuffle($threshold..$threshold + 5)]->[0];
                    # other status
                    $hash->{status}->{atk} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{ldr} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{agi} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{skl} = [List::Util::shuffle(9..$threshold - $distance)]->[0];

                    my $job              = Games::Growth::Model::Character::Job->search_job($hash->{status});
                    my $status_as_string = join(',', map { "$_:$hash->{status}->{$_}" } qw/atk def ldr agi vit skl/);
                    is $job->{name},  $job_name, sprintf("search_job name: %s => %s", $job_name, $status_as_string);
                    is $job->{score}, $threshold, 'search_job score';
                }
            };
        };

        describe 'case match def and skl professional' => sub {
            before_all "setup job-list" => sub {
                $hash->{threshold_point} = [12, 22, 42];
                $hash->{distance}        = [2,   3,  4];
                $hash->{job_names}       = [qw/Debuffer   Phalanx     Unbreakable/];
                $hash->{status}          = Games::Growth::Model::Character->initial_character->{status}
            };

            it "should return def-skl job" => sub {
                for my $entries (0..2){
                    my $threshold = $hash->{threshold_point}->[$entries];
                    my $distance  = $hash->{distance}->[$entries];
                    my $job_name  = $hash->{job_names}->[$entries];

                    # target status
                    $hash->{status}->{def} = [List::Util::shuffle($threshold..$threshold + 5)]->[0];
                    $hash->{status}->{skl} = [List::Util::shuffle($threshold..$threshold + 5)]->[0];
                    # other status
                    $hash->{status}->{atk} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{ldr} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{agi} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{vit} = [List::Util::shuffle(9..$threshold - $distance)]->[0];

                    my $job              = Games::Growth::Model::Character::Job->search_job($hash->{status});
                    my $status_as_string = join(',', map { "$_:$hash->{status}->{$_}" } qw/atk def ldr agi vit skl/);
                    is $job->{name},  $job_name, sprintf("search_job name: %s => %s", $job_name, $status_as_string);
                    is $job->{score}, $threshold, 'search_job score';
                }
            };
        };

        describe 'case match ldr and agi professional' => sub {
            before_all "setup job-list" => sub {
                $hash->{threshold_point} = [12, 22, 42];
                $hash->{distance}        = [2,   3,  4];
                $hash->{job_names}       = [qw/Messenger  Herald      Warbird/];
                $hash->{status}          = Games::Growth::Model::Character->initial_character->{status}
            };

            it "should return ldr-agi job" => sub {
                for my $entries (0..2){
                    my $threshold = $hash->{threshold_point}->[$entries];
                    my $distance  = $hash->{distance}->[$entries];
                    my $job_name  = $hash->{job_names}->[$entries];

                    # target status
                    $hash->{status}->{ldr} = [List::Util::shuffle($threshold..$threshold + 5)]->[0];
                    $hash->{status}->{agi} = [List::Util::shuffle($threshold..$threshold + 5)]->[0];
                    # other status
                    $hash->{status}->{atk} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{def} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{vit} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{skl} = [List::Util::shuffle(9..$threshold - $distance)]->[0];

                    my $job              = Games::Growth::Model::Character::Job->search_job($hash->{status});
                    my $status_as_string = join(',', map { "$_:$hash->{status}->{$_}" } qw/atk def ldr agi vit skl/);
                    is $job->{name},  $job_name, sprintf("search_job name: %s => %s", $job_name, $status_as_string);
                    is $job->{score}, $threshold, 'search_job score';
                }
            };
        };

        describe 'case match ldr and vit professional' => sub {
            before_all "setup job-list" => sub {
                $hash->{threshold_point} = [12, 22, 42];
                $hash->{distance}        = [2,   3,  4];
                $hash->{job_names}       = [qw/Supporter  Soldier     Bastion/];
                $hash->{status}          = Games::Growth::Model::Character->initial_character->{status}
            };

            it "should return ldr-vit job" => sub {
                for my $entries (0..2){
                    my $threshold = $hash->{threshold_point}->[$entries];
                    my $distance  = $hash->{distance}->[$entries];
                    my $job_name  = $hash->{job_names}->[$entries];

                    # target status
                    $hash->{status}->{ldr} = [List::Util::shuffle($threshold..$threshold + 5)]->[0];
                    $hash->{status}->{vit} = [List::Util::shuffle($threshold..$threshold + 5)]->[0];
                    # other status
                    $hash->{status}->{atk} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{def} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{agi} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{skl} = [List::Util::shuffle(9..$threshold - $distance)]->[0];

                    my $job              = Games::Growth::Model::Character::Job->search_job($hash->{status});
                    my $status_as_string = join(',', map { "$_:$hash->{status}->{$_}" } qw/atk def ldr agi vit skl/);
                    is $job->{name},  $job_name, sprintf("search_job name: %s => %s", $job_name, $status_as_string);
                    is $job->{score}, $threshold, 'search_job score';
                }
            };
        };

        describe 'case match ldr and skl professional' => sub {
            before_all "setup job-list" => sub {
                $hash->{threshold_point} = [12, 22, 42];
                $hash->{distance}        = [2,   3,  4];
                $hash->{job_names}       = [qw/Buffer     Signmaker   Tactician/];
                $hash->{status}          = Games::Growth::Model::Character->initial_character->{status}
            };

            it "should return ldr-skl job" => sub {
                for my $entries (0..2){
                    my $threshold = $hash->{threshold_point}->[$entries];
                    my $distance  = $hash->{distance}->[$entries];
                    my $job_name  = $hash->{job_names}->[$entries];

                    # target status
                    $hash->{status}->{ldr} = [List::Util::shuffle($threshold..$threshold + 5)]->[0];
                    $hash->{status}->{skl} = [List::Util::shuffle($threshold..$threshold + 5)]->[0];
                    # other status
                    $hash->{status}->{atk} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{def} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{agi} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{vit} = [List::Util::shuffle(9..$threshold - $distance)]->[0];

                    my $job              = Games::Growth::Model::Character::Job->search_job($hash->{status});
                    my $status_as_string = join(',', map { "$_:$hash->{status}->{$_}" } qw/atk def ldr agi vit skl/);
                    is $job->{name},  $job_name, sprintf("search_job name: %s => %s", $job_name, $status_as_string);
                    is $job->{score}, $threshold, 'search_job score';
                }
            };
        };

        describe 'case match agi and vit professional' => sub {
            before_all "setup job-list" => sub {
                $hash->{threshold_point} = [12, 22, 42];
                $hash->{distance}        = [2,   3,  4];
                $hash->{job_names}       = [qw/Scout      Ranger      Survivor/];
                $hash->{status}          = Games::Growth::Model::Character->initial_character->{status}
            };

            it "should return agi-vit job" => sub {
                for my $entries (0..2){
                    my $threshold = $hash->{threshold_point}->[$entries];
                    my $distance  = $hash->{distance}->[$entries];
                    my $job_name  = $hash->{job_names}->[$entries];

                    # target status
                    $hash->{status}->{agi} = [List::Util::shuffle($threshold..$threshold + 5)]->[0];
                    $hash->{status}->{vit} = [List::Util::shuffle($threshold..$threshold + 5)]->[0];
                    # other status
                    $hash->{status}->{atk} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{def} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{ldr} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{skl} = [List::Util::shuffle(9..$threshold - $distance)]->[0];

                    my $job              = Games::Growth::Model::Character::Job->search_job($hash->{status});
                    my $status_as_string = join(',', map { "$_:$hash->{status}->{$_}" } qw/atk def ldr agi vit skl/);
                    is $job->{name},  $job_name, sprintf("search_job name: %s => %s", $job_name, $status_as_string);
                    is $job->{score}, $threshold, 'search_job score';
                }
            };
        };

        describe 'case match agi and skl professional' => sub {
            before_all "setup job-list" => sub {
                $hash->{threshold_point} = [12, 22, 42];
                $hash->{distance}        = [2,   3,  4];
                $hash->{job_names}       = [qw/Thief      Assassin    Eraser/];
                $hash->{status}          = Games::Growth::Model::Character->initial_character->{status}
            };

            it "should return agi-skl job" => sub {
                for my $entries (0..2){
                    my $threshold = $hash->{threshold_point}->[$entries];
                    my $distance  = $hash->{distance}->[$entries];
                    my $job_name  = $hash->{job_names}->[$entries];

                    # target status
                    $hash->{status}->{agi} = [List::Util::shuffle($threshold..$threshold + 5)]->[0];
                    $hash->{status}->{skl} = [List::Util::shuffle($threshold..$threshold + 5)]->[0];
                    # other status
                    $hash->{status}->{atk} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{def} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{ldr} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{vit} = [List::Util::shuffle(9..$threshold - $distance)]->[0];

                    my $job              = Games::Growth::Model::Character::Job->search_job($hash->{status});
                    my $status_as_string = join(',', map { "$_:$hash->{status}->{$_}" } qw/atk def ldr agi vit skl/);
                    is $job->{name},  $job_name, sprintf("search_job name: %s => %s", $job_name, $status_as_string);
                    is $job->{score}, $threshold, 'search_job score';
                }
            };
        };

        describe 'case match vit and skl professional' => sub {
            before_all "setup job-list" => sub {
                $hash->{threshold_point} = [12, 22, 42];
                $hash->{distance}        = [2,   3,  4];
                $hash->{job_names}       = [qw/Binder    Counter     Trickster/];
                $hash->{status}          = Games::Growth::Model::Character->initial_character->{status}
            };

            it "should return vit-skl job" => sub {
                for my $entries (0..2){
                    my $threshold = $hash->{threshold_point}->[$entries];
                    my $distance  = $hash->{distance}->[$entries];
                    my $job_name  = $hash->{job_names}->[$entries];

                    # target status
                    $hash->{status}->{vit} = [List::Util::shuffle($threshold..$threshold + 5)]->[0];
                    $hash->{status}->{skl} = [List::Util::shuffle($threshold..$threshold + 5)]->[0];
                    # other status
                    $hash->{status}->{atk} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{def} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{ldr} = [List::Util::shuffle(9..$threshold - $distance)]->[0];
                    $hash->{status}->{agi} = [List::Util::shuffle(9..$threshold - $distance)]->[0];

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
