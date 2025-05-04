use 5.40.0;
use autodie;
use utf8;

use List::Util qw/sum/;
use Test2::V0;
use Test2::Tools::Spec;
use Test2::Plugin::SRand seed => time;

use Games::Growth::Model::Character;

describe 'about Games::Growth::Model::Character#calculate_status' => sub {
    my $hash;

    describe 'character gains enough experience to level up' => sub {
        before_all "setup initial character with experience for level 4" => sub {
            $hash->{character}                  = Games::Growth::Model::Character->initial_character();
            $hash->{character}->{experience} = 2400;  # Enough for level 4 (assuming 800 experience per level)
        };

        it 'levels up without side effects and increases status points' => sub {
            is $hash->{character}->{level},          1,    'before calculate';
            is $hash->{character}->{experience},            2400, 'before calculate';
            is $hash->{character}->{status}->{atk} +
               $hash->{character}->{status}->{def} +
               $hash->{character}->{status}->{ldr} +
               $hash->{character}->{status}->{agi} +
               $hash->{character}->{status}->{vit} +
               $hash->{character}->{status}->{skl},  30, 'before calculate';
            my %character = %{$hash->{character}};

            my $updated = Games::Growth::Model::Character->calculate_status($hash->{character});
            is %character,                                         %{$hash->{character}}, 'no side effects';
            is $updated->{level},                                  4,                     'after calculate';
            is sum(map { $_ - 5 } values %{ $updated->{status} }), 3 * 2,                 'gained 6 status points (3 levels * 2)';
        };
    };

    describe 'character gains small experience but does not level up' => sub {
        before_all "setup character with insufficient experience for next level" => sub {
            $hash->{character} = Games::Growth::Model::Character->initial_character();
            $hash->{character}->{experience} = 799;  # Just below threshold for level 2
        };

        it 'does not level up or change status' => sub {
            is $hash->{character}->{level},                     1, 'initial level';
            is $hash->{character}->{experience},                     799, 'initial experience';
            is sum(values %{ $hash->{character}->{status} }),  30, 'initial status sum';

            my $updated = Games::Growth::Model::Character->calculate_status($hash->{character});
            is $updated, +{}, 'no update returned';
        };
    };

    describe 'character reincarnates when status exceeds 50' => sub {
        before_all "setup character with high stats" => sub {
             $hash->{character} = Games::Growth::Model::Character->initial_character();
             $hash->{character}->{experience}    = 105600 + 800;
             $hash->{character}->{gen}    = 0;
             $hash->{character}->{level}  = 133;
             $hash->{character}->{status} = +{
                atk => 49,
                def => 49,
                ldr => 49,
                agi => 49,
                vit => 49,
                skl => 49,
            };
        };

        it 'should reincarnate when any status exceeds 50' => sub {
            my $updated = Games::Growth::Model::Character->calculate_status($hash->{character});
            is $updated, +{ gen => 1 }, 'generation incremented after reincarnation';
        };
    };

    describe 'case level up triggers job assignment' => sub {
        before_all 'prepare status close to job criteria' => sub {
            $hash->{character} = Games::Growth::Model::Character->initial_character();
            $hash->{character}->{experience}    = 14400 + 800;
            $hash->{character}->{level}  = 19;
            $hash->{character}->{status} = +{
                atk => 11,
                def => 11,
                ldr => 11,
                agi => 11,
                vit => 11,
                skl => 11,
            };
        };

        it 'should assign new job with name and score after status growth' => sub {
            my $updated = Games::Growth::Model::Character->calculate_status($hash->{character});
            is $updated->{level},        20, 'level up confirmed';
            ok $updated->{job}->{name},      'job name assigned';
            ok $updated->{job}->{score},     'job score assigned';
        };
    };
};

done_testing;
