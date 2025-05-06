use Test2::V0;
use Test2::Tools::Spec;

use Games::Growth::Service::CharacterService;

describe 'about Games::Growth::Service::CharacterService#create_character' => sub {
    my $hash;

    describe 'Negative testing' => sub {
        describe 'case already character setted' => sub {
            before_all 'create instance' => sub {
                my $service = Games::Growth::Service::CharacterService->new();
                $service->create_character('Alice');
                $hash->{service} = $service;
            };

            it 'should throw exception' => sub {
                my $service = $hash->{service};
                my $throws = dies {
                    $service->create_character('Bob');
                };
                like $throws, qr/character already set/, 'should throw exception for already set character';
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
                    $service->create_character(undef);
                };
                like $throws, qr/did not pass type constraint "Str"/, 'should throw exception for invalid character';
            };
        };
    };

    describe 'positive testing' => sub {
        describe 'case call constructor with out arguments' => sub {
            before_all 'create instance' => sub {
                my $service = Games::Growth::Service::CharacterService->new();
                $hash->{service} = $service;
            };

            it 'should return instance' => sub {
                my $service = $hash->{service};
                my $res     = $service->create_character('Charlie');

                isa_ok $res,             ['Games::Growth::Service::CharacterService'], 'should return instance';
                is     $service,         $res,                                         'should same instance';
                is     $service->name(), 'Charlie',                                    'should return name';
            };
        };
    };
};

done_testing;
