use Test2::V0;
use Test2::Tools::Spec;

use Games::Growth::Service::CharacterService;

describe 'about Games::Growth::Service::CharacterService#output_character' => sub {
    my $hash;

    describe 'Negative testing' => sub {

        describe 'case character not setted' => sub {
            before_all 'create instance' => sub {
                my $service = Games::Growth::Service::CharacterService->new(
                    name     => 'Alice',
                );
                $hash->{service} = $service;
            };

            it 'should throw exception' => sub {
                my $service = $hash->{service};
                my $throws = dies {
                    $service->output_character;
                };
                like $throws, qr/character not set/, 'should throw exception for already set character';
            };
        };

        describe 'case Name not setted' => sub {
            before_all 'create instance' => sub {
                my $service = Games::Growth::Service::CharacterService->new(
                    character => Games::Growth::Model::Character->initial_character
                );
                $hash->{service} = $service;
            };

            it 'should throw exception' => sub {
                my $service = $hash->{service};
                my $throws = dies {
                    $service->output_character;
                };
                like $throws, qr/did not pass type constraint "Str"/, 'should throw exception for invalid name';
            };
        };
    };

    describe 'positive testing' => sub {
        describe 'case not updated character' => sub {
            before_all 'create instance' => sub {
                my $service = Games::Growth::Service::CharacterService->new(
                    name      => 'Bob',
                    character => Games::Growth::Model::Character->initial_character
                );
                $hash->{service} = $service;
            };

            it 'should return instance' => sub {
                my $service = $hash->{service};
                my $res     = $service->output_character();

                ref_ok $res,             'HASH', 'should return Hashref';

                my $name         = $res->{name};
                my $character    = $res->{character};
                my $updated_info = $res->{updated_info};

                is $name,               'Bob', 'should return name';
                is $character->{level}, 1,     'should return character level';
                is $updated_info,       +{},   'should return empty updated info'
            };
        };

        describe 'case updated character' => sub {
            before_all 'create instance' => sub {
                my $service = Games::Growth::Service::CharacterService->new(
                    name      => 'Bob',
                    character => Games::Growth::Model::Character->initial_character
                );
                $service->gain_experience(800)->calculate_status;
                $hash->{service} = $service;
            };

            it 'should return instance' => sub {
                my $service = $hash->{service};
                my $res     = $service->output_character();

                ref_ok $res,             'HASH', 'should return Hashref';

                my $name         = $res->{name};
                my $character    = $res->{character};
                my $updated_info = $res->{updated_info};

                is $name,                         'Bob', 'should return name';
                is $character->{level},            2,    'should return character level';
                is $updated_info->{level},         2,    'should return updated level';
                is exists $updated_info->{status}, 1,    'should return updated status';
            };
        };

    };
};

done_testing;
