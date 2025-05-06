use Test2::V0;
use Test2::Tools::Spec;

use Games::Growth::Service::CharacterService;

describe 'about Games::Growth::Service::CharacterService#calculate_status' => sub {
    my $hash;

    describe 'Negative testing' => sub {
        describe 'case character not setted' => sub {
            before_all 'create instance' => sub {
                my $service = Games::Growth::Service::CharacterService->new();
                $hash->{service} = $service;
            };

            it 'should throw exception' => sub {
                my $service = $hash->{service};
                my $throws = dies {
                    $service->calculate_status();
                };
                like $throws, qr/character not set/, 'should throw exception for already set character';
            };
        };
    };

    describe 'positive testing' => sub {
        describe 'case call constructor with out arguments' => sub {
            before_all 'create instance' => sub {
                my $service = Games::Growth::Service::CharacterService->new();
                $service->create_character('Bob');
                $hash->{service} = $service;
            };

            it 'should return instance' => sub {
                my $service = $hash->{service};
                $service->gain_experience(800);

                is     $service->character()->{level}, 1,                                            'should return level 1';

                my $res     = $service->calculate_status();

                isa_ok $res,                           ['Games::Growth::Service::CharacterService'], 'should return instance';
                is     $res,                            $service,                                    'should same instance';
                is     $service->name(),               'Bob',                                        'should return name';
                is     $service->character()->{level}, 2,                                            'should return level 2';
            };
        };
    };
};

done_testing;
