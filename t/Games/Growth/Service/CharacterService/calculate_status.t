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
            describe 'scenario level-up' => sub {
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

            describe 'scenario reincarnation' => sub {
                before_all 'create instance' => sub {
                    my $character = Games::Growth::Model::Character->initial_character();
                    $character->{status} = +{
                        atk => 49,
                        def => 49,
                        ldr => 49,
                        agi => 49,
                        vit => 49,
                        skl => 49,
                    };
                    $character->{experience} = 105600 + 800;
                    $character->{level}      = 132;
                    my $service = Games::Growth::Service::CharacterService->new(
                        character => $character,
                        name      => 'Charlie',
                    );
                    $hash->{service} = $service;
                };

                it 'should return instance' => sub {
                    my $service = $hash->{service};
                    $service->gain_experience(105600 + 800);

                    is     $service->character()->{level},      132,                                     'should return level 1';
                    is     $service->character()->{generation}, 0,                                       'should return generation 0';

                    my $res     = $service->calculate_status();

                    isa_ok $res,                           ['Games::Growth::Service::CharacterService'], 'should return instance';
                    is     $res,                            $service,                                    'should same instance';
                    is     $service->character()->{level},         1,                                    'should return level 1';
                    is     $service->character()->{generation},    1,                                    'should return generation 1';
                    is     $service->character()->{status}->{atk}, 5,                                    'should return status atk 0';
                };
            };
        };
    };
};

done_testing;
