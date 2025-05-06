use Test2::V0;
use Test2::Tools::Spec;

use Games::Growth::Service::CharacterService;
use Games::Growth::Model::Character;

describe 'about Games::Growth::Service::CharacterService#new' => sub {
    my $hash;

    describe 'Negative testing' => sub {
        describe 'case call constructor with type mismatch arguments' => sub {
            it 'should throw exception' => sub {
                my $throws = dies {
                    Games::Growth::Service::CharacterService->new(
                        name      => 'Alice',
                        character => 'invalid',
                    );
                };
                like $throws, qr/did not pass type constraint "HashRef"/, 'should throw exception for invalid character';
            };

            it 'should throw exception' => sub {
                my $throws = dies {
                    Games::Growth::Service::CharacterService->new(
                        name      => undef,
                        character => { name => 'Bob' },
                    );
                };
                like $throws, qr/did not pass type constraint "Str"/, 'should throw exception for invalid name';
            };
        };
    };

    describe 'positive testing' => sub {
        describe 'case call constructor with out arguments' => sub {
            it 'should return service' => sub {
                my $service = Games::Growth::Service::CharacterService->new();
                isa_ok $service, ['Games::Growth::Service::CharacterService'], 'should return service';
            };
        };

        describe 'case call constructor with valid arguments' => sub {
            it 'should return service' => sub {
                my $service = Games::Growth::Service::CharacterService->new(
                    name      => 'Alice',
                    character => Games::Growth::Model::Character->initial_character(),
                );
                isa_ok $service,                      ['Games::Growth::Service::CharacterService'], 'should return service';
                is     $service->name(),               'Alice',                                     'should return name';
                is     $service->character()->{level}, 1,                                           'should return character level';
            };
        };
    };
};

done_testing;
