use 5.40.0;
use autodie;
use utf8;

use List::Util qw/sum/;
use Test2::V0;
use Test2::Tools::Spec;

use Games::Growth::Model::Character;

describe 'Games::Growth::Model::Character#initial_character' => sub {
    my $hash;

    before_all 'create character' => sub {
        $hash->{character} = Games::Growth::Model::Character->initial_character();
    };

    it 'should return HashRef with expected keys' => sub {
        my $character = $hash->{character};
        ref_ok $character,                'HASH',                                            'is a hash reference';
        is     [ sort keys %$character ], [qw/experience generation job last_updated_epoch level resume status/], 'top-level keys are correct';
    };

    it 'should initialize status with default values' => sub {
        my $status = $hash->{character}->{status};
        ref_ok $status,                'HASH',                                            'is a hash reference';
        is     $status, +{
            agi => $Games::Growth::Model::Character::DEFAULT_STATUS_VALUE,
            atk => $Games::Growth::Model::Character::DEFAULT_STATUS_VALUE,
            def => $Games::Growth::Model::Character::DEFAULT_STATUS_VALUE,
            ldr => $Games::Growth::Model::Character::DEFAULT_STATUS_VALUE,
            skl => $Games::Growth::Model::Character::DEFAULT_STATUS_VALUE,
            vit => $Games::Growth::Model::Character::DEFAULT_STATUS_VALUE,
        }, 'status initialized with default values';
    };

    it 'should set level, exp, gen to defaults' => sub {
        my $character = $hash->{character};
        is $hash->{character}->{level}, 1, 'level initialized to 1';
        is $hash->{character}->{experience}, 0, 'experience initialized to 0';
        is $hash->{character}->{generation}, 0, 'generation initialized to 0';
    };

    it 'should set job as a HashRef with name and score' => sub {
        my $character = $hash->{character};

        is $character->{job}, hash {
            field 'name'  => match(qr/\A.+\z/);
            field 'score' => match(qr/\A[0-9]+\z/);
        }, 'job initialized as expected';
    };

    it 'should initialize resume as an empty arrayref' => sub {
        my $character = $hash->{character};
        is $character->{resume}, [], 'resume is empty arrayref';
    };

    it 'should set last_update to current time (approximately)' => sub {
        my $character = $hash->{character};
        like $character->{last_updated_epoch}, qr/\A\d+\z/, 'last_updated_epoch is epoch time';
    }
};

done_testing;
