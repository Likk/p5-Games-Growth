use 5.40.0;
use autodie;
use utf8;

use List::Util qw/sum/;
use Test2::V0;
use Test2::Tools::Spec;

use Games::Growth::Model::Character;

describe 'about Games::Growth::Model::Character#apply_experience_bonus' => sub {
    my $hash;

    before_all "base_experience is 1000" => sub {
        $hash->{base_experience}           = 1000;
    };

    describe 'case login_bonus and duration_bonus are not enabled' => sub {

        before_all "login_bonus and duration_bonus are not enabled" => sub {
            $hash->{use_login_bonus}    = 0;
            $hash->{use_duration_bonus} = 0;
        };

        describe 'last_updated_epoch is now' => sub {
            before_all "create receiver" => sub {
                $hash->{last_updated_epoch} = time();
            };
            it 'experience is not updated' => sub {
                my $updated_experience = Games::Growth::Model::Character->apply_experience_bonus(
                    base_experience    => $hash->{base_experience},
                    last_updated_epoch => $hash->{last_updated_epoch},
                    use_login_bonus    => $hash->{use_login_bonus},
                    use_duration_bonus => $hash->{use_duration_bonus},
                );
                is $updated_experience, $hash->{base_experience}, 'same experience';
            };
        };

        describe 'last_updated_epoch is 3 days ago' => sub {
            before_all "create receiver" => sub {
                $hash->{last_updated_epoch} = time() - 3 * 24 * 60 * 60;
            };
            it 'experience is not updated' => sub {
                my $updated_experience = Games::Growth::Model::Character->apply_experience_bonus(
                    base_experience    => $hash->{base_experience},
                    last_updated_epoch => $hash->{last_updated_epoch},
                    use_login_bonus    => $hash->{use_login_bonus},
                    use_duration_bonus => $hash->{use_duration_bonus},
                );
                is $updated_experience, $hash->{base_experience}, 'same experience';
            };
        };
    };

    describe 'case login_bonus is enabled, and duration_bonus is not enabled' => sub {
        before_all "login_bonus is enabled, and duration_bonus is not enabled" => sub {
            $hash->{use_login_bonus}    = 1;
            $hash->{use_duration_bonus} = 0;
        };

        describe 'last_updated_epoch is now' => sub {
            before_all "create receiver" => sub {
                $hash->{last_updated_epoch} = time();
            };
            it 'experience is not updated' => sub {
                my $updated_experience = Games::Growth::Model::Character->apply_experience_bonus(
                    base_experience    => $hash->{base_experience},
                    last_updated_epoch => $hash->{last_updated_epoch},
                    use_login_bonus    => $hash->{use_login_bonus},
                    use_duration_bonus => $hash->{use_duration_bonus},
                );
                is $updated_experience, $hash->{base_experience}, 'same experience';
            };
        };

        # after DURATION_BONUS_START_SEC.
        describe 'last_updated_epoch is 3 hours ago' => sub {
            before_all "create receiver" => sub {
                $hash->{last_updated_epoch} = time() - 3 * 60 * 60;
            };
            it 'experience is updated' => sub {
                my $updated_experience = Games::Growth::Model::Character->apply_experience_bonus(
                    base_experience    => $hash->{base_experience},
                    last_updated_epoch => $hash->{last_updated_epoch},
                    use_login_bonus    => $hash->{use_login_bonus},
                    use_duration_bonus => $hash->{use_duration_bonus},
                );
                is $updated_experience, $hash->{base_experience}, 'same experience';
            };
        };

        # after COMEBACK_BONUS_START_SEC
        describe 'last_updated_epoch is 3 days ago' => sub {
            before_all "create receiver" => sub {
                $hash->{last_updated_epoch} = time() - 3 * 24 * 60 * 60;
            };
            it 'experience is updated' => sub {
                my $updated_experience = Games::Growth::Model::Character->apply_experience_bonus(
                    base_experience    => $hash->{base_experience},
                    last_updated_epoch => $hash->{last_updated_epoch},
                    use_login_bonus    => $hash->{use_login_bonus},
                    use_duration_bonus => $hash->{use_duration_bonus},
                );
                is $updated_experience, $hash->{base_experience} + 200, 'got login_bonus';
            };
        };
    };

    describe 'case login_bonus is not enabled, and duration_bonus is enabled' => sub {
        before_all "login_bonus is not enabled, and duration_bonus is enabled" => sub {
            $hash->{use_login_bonus}    = 0;
            $hash->{use_duration_bonus} = 1;
        };

        describe 'last_updated_epoch is now' => sub {
            before_all "create receiver" => sub {
                $hash->{last_updated_epoch} = time();
            };
            it 'experience is not updated' => sub {
                my $updated_experience = Games::Growth::Model::Character->apply_experience_bonus(
                    base_experience    => $hash->{base_experience},
                    last_updated_epoch => $hash->{last_updated_epoch},
                    use_login_bonus    => $hash->{use_login_bonus},
                    use_duration_bonus => $hash->{use_duration_bonus},
                );
                is $updated_experience, $hash->{base_experience}, 'same experience';
            };
        };

        # before DURATION_BONUS_START_SEC.
        describe 'last_updated_epoch is 2 hours and 59 minuites ago' => sub {
            before_all "create receiver" => sub {
                $hash->{last_updated_epoch} = time() - 2 * 60 * 60 - 59 * 60;
            };
            it 'experience is not updated' => sub {
                my $updated_experience = Games::Growth::Model::Character->apply_experience_bonus(
                    base_experience    => $hash->{base_experience},
                    last_updated_epoch => $hash->{last_updated_epoch},
                    use_login_bonus    => $hash->{use_login_bonus},
                    use_duration_bonus => $hash->{use_duration_bonus},
                );
                is $updated_experience, $hash->{base_experience}, 'same experience';
            };
        };

        # after DURATION_BONUS_START_SEC.
        describe 'last_updated_epoch is 3 hours ago' => sub {
            before_all "create receiver" => sub {
                $hash->{last_updated_epoch} = time() - 3 * 60 * 60;
            };
            it 'experience is updated' => sub {
                my $updated_experience = Games::Growth::Model::Character->apply_experience_bonus(
                    base_experience    => $hash->{base_experience},
                    last_updated_epoch => $hash->{last_updated_epoch},
                    use_login_bonus    => $hash->{use_login_bonus},
                    use_duration_bonus => $hash->{use_duration_bonus},
                );
                is $updated_experience, $hash->{base_experience} + 10, 'got duration_bonus';
            };
        };

        # after LOGIN_BONUS
        describe 'last_updated_epoch is 1 day ago' => sub {
            before_all "create receiver" => sub {
                $hash->{last_updated_epoch} = time() - 1 * 24 * 60 * 60;
            };
            it 'experience is updated' => sub {
                my $updated_experience = Games::Growth::Model::Character->apply_experience_bonus(
                    base_experience    => $hash->{base_experience},
                    last_updated_epoch => $hash->{last_updated_epoch},
                    use_login_bonus    => $hash->{use_login_bonus},
                    use_duration_bonus => $hash->{use_duration_bonus},
                );
                is $updated_experience, $hash->{base_experience} + 86, 'got duration_bonus only';
            };
        };

        # after COMEBACK_BONUS
        describe 'last_updated_epoch is 3 days ago' => sub {
            before_all "create receiver" => sub {
                $hash->{last_updated_epoch} = time() - 3 * 24 * 60 * 60;
            };
            it 'experience is updated' => sub {
                my $updated_experience = Games::Growth::Model::Character->apply_experience_bonus(
                    base_experience    => $hash->{base_experience},
                    last_updated_epoch => $hash->{last_updated_epoch},
                    use_login_bonus    => $hash->{use_login_bonus},
                    use_duration_bonus => $hash->{use_duration_bonus},
                );
                is $updated_experience, $hash->{base_experience} + int(259 * 1.5), 'got duration_bonus with comeback_bonus';
            };
        };
    };


    describe 'case login_bonus is not enabled, and duration_bonus is enabled' => sub {
        before_all "login_bonus and duration_bonus are enabled" => sub {
            $hash->{use_login_bonus}    = 1;
            $hash->{use_duration_bonus} = 1;
        };

        describe 'last_updated_epoch is now' => sub {
            before_all "create receiver" => sub {
                $hash->{last_updated_epoch} = time();
            };
            it 'experience is not updated' => sub {
                my $updated_experience = Games::Growth::Model::Character->apply_experience_bonus(
                    base_experience    => $hash->{base_experience},
                    last_updated_epoch => $hash->{last_updated_epoch},
                    use_login_bonus    => $hash->{use_login_bonus},
                    use_duration_bonus => $hash->{use_duration_bonus},
                );
                is $updated_experience, $hash->{base_experience}, 'same experience';
            };
        };

        # before DURATION_BONUS_START_SEC.
        describe 'last_updated_epoch is 2 hours and 59 minuites ago' => sub {
            before_all "create receiver" => sub {
                $hash->{last_updated_epoch} = time() - 2 * 60 * 60 - 59 * 60;
            };
            it 'experience is not updated' => sub {
                my $updated_experience = Games::Growth::Model::Character->apply_experience_bonus(
                    base_experience    => $hash->{base_experience},
                    last_updated_epoch => $hash->{last_updated_epoch},
                    use_login_bonus    => $hash->{use_login_bonus},
                    use_duration_bonus => $hash->{use_duration_bonus},
                );
                is $updated_experience, $hash->{base_experience}, 'same experience';
            };
        };

        # after DURATION_BONUS_START_SEC.
        describe 'last_updated_epoch is 3 hours ago' => sub {
            before_all "create receiver" => sub {
                $hash->{last_updated_epoch} = time() - 3 * 60 * 60;
            };
            it 'experience is updated' => sub {
                my $updated_experience = Games::Growth::Model::Character->apply_experience_bonus(
                    base_experience    => $hash->{base_experience},
                    last_updated_epoch => $hash->{last_updated_epoch},
                    use_login_bonus    => $hash->{use_login_bonus},
                    use_duration_bonus => $hash->{use_duration_bonus},
                );
                is $updated_experience, $hash->{base_experience} + 10, 'got duration_bonus';
            };
        };

        # after LOGIN_BONUS
        describe 'last_updated_epoch is 1 day ago' => sub {
            before_all "create receiver" => sub {
                $hash->{last_updated_epoch} = time() - 1 * 24 * 60 * 60;
            };
            it 'experience is updated' => sub {
                my $updated_experience = Games::Growth::Model::Character->apply_experience_bonus(
                    base_experience    => $hash->{base_experience},
                    last_updated_epoch => $hash->{last_updated_epoch},
                    use_login_bonus    => $hash->{use_login_bonus},
                    use_duration_bonus => $hash->{use_duration_bonus},
                );
                is $updated_experience, $hash->{base_experience} + 86 + 200, 'got duration_bonus and login_bonus';
            };
        };

        # after COMEBACK_BONUS
        describe 'last_updated_epoch is 3 days ago' => sub {
            before_all "create receiver" => sub {
                $hash->{last_updated_epoch} = time() - 3 * 24 * 60 * 60;
            };
            it 'experience is updated' => sub {
                my $updated_experience = Games::Growth::Model::Character->apply_experience_bonus(
                    base_experience    => $hash->{base_experience},
                    last_updated_epoch => $hash->{last_updated_epoch},
                    use_login_bonus    => $hash->{use_login_bonus},
                    use_duration_bonus => $hash->{use_duration_bonus},
                );
                is $updated_experience, $hash->{base_experience} + int(259 * 1.5) + 200, 'got duration_bonus with comeback_bonus and login_bonus';
            };
        };
    };
};

done_testing;
