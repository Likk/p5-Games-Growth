use Test2::V0;
use Test2::Tools::Spec;

use Games::Growth::Service::CharacterService;

describe 'about Games::Growth::Service::CharacterService#gain_experience' => sub {
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
                    $service->gain_experience(800);
                };
                like $throws, qr/character not set/, 'should throw exception for already set character';
            };
        };

        describe 'case arguments type mismatch' => sub {
            before_all 'create instance' => sub {
                my $service = Games::Growth::Service::CharacterService->new();
                $hash->{service} = $service;
            };
            it 'should throw exception' => sub {
                my $service = $hash->{service};
                my $throws = dies {
                    $service->gain_experience('one thousand');
                };
                like $throws, qr/did not pass type constraint "Int"/, 'should throw exception for invalid character';
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
                my $res     = $service->gain_experience(800);

                isa_ok $res,                                ['Games::Growth::Service::CharacterService'], 'should return instance';
                is     $res,                                $service,                                     'should same instance';
                is     $service->name(),                    'Bob',                                        'should return name';
                is     $service->character()->{experience}, 800,                                          'should return character experience';
            };
        };
    };
};

done_testing;
