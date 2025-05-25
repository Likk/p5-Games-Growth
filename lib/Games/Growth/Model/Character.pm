package Games::Growth::Model::Character;
use 5.40.0;
use utf8;

use Clone qw/clone/;
use Function::Parameters;
use Function::Return;
use Types::Standard -types;

use List::Util qw/shuffle sum max/;
use Time::Piece;

use Games::Growth::Model::Character::Job;

=head1 NAME

  Games::Growth::Model::Character - A character growth and status management module

=head1 DESCRIPTION

  Games::Growth::Model::Character is a character status and growth model.

  This class manages the data and logic associated with a character.
  It represents a character's attributes and behaviors in a game or simulation.
  Specifically, it handles the character's status (such as atk, def, agi, etc.), growth system (including jobs, level-ups, and stat progression), and other character-specific information.

  HP and MP are not supported. Instead, this class uses vit (durability) and skl (skill) parameters to derive various aspects of character capability.

=head1 SYNOPSIS


  my $status = Games::Growth::Model::Character->initial_character();
  $status->{experience} += 1000;
  $status = Games::Growth::Model::Character->calculate_status($status); # Level up

=head1 CONFIGURATION VARIABLES

=head2 BASIC GROWTH SETTINGS

=over 4

=item * $EXPERIENCE_PER_LEVEL

  Experience points required for one level up.

=item * $STATUS_POINTS_PER_LEVEL

  Total status points gained per level up.

=item * $MAX_STATUS_VALUE

  Maximum allowed value for any status.

=item * $DEFAULT_STATUS_VALUE

  The default value assigned to each stat (e.g., atk, def, etc.) when initializing a character. Defaults to 5.

=back

=cut

our $EXPERIENCE_PER_LEVEL      = 800;
our $STATUS_POINTS_PER_LEVEL   = 2;
our $MAX_STATUS_VALUE          = 50;
our $DEFAULT_STATUS_VALUE      = 5;

=head2 BONUS EXPERIENCE fOR ACTIONS

=over 4

=item * $ENABLE_LOGIN_BONUS

  Enable or disable login bonus.

=item * $LOGIN_BONUS_EXPERIENCE

  Experience points awarded for the first action of the day.

=back

=cut

our $ENABLE_LOGIN_BONUS        = true;
our $LOGIN_BONUS_EXPERIENCE    = 200;

=head2 TIME-BASED BONUS SYSTEM

=over 4

=item * $ENABLE_DURATION_BONUS

  Enable or disable experience bonus based on elapsed time.

=item * $DURATION_BONUS_MULTIPLIER

  Multiplier applied to elapsed seconds for bonus experience.

=item * $DURATION_BONUS_START_SEC

  Minimum elapsed time in seconds to trigger duration bonus.

=item * $ENABLE_COMEBACK_BONUS

  Enable or disable comeback bonus.

=item * $COMEBACK_BONUS_RATE

  Multiplier applied to experience points for comeback bonus.

=item * $COMEBACK_BONUS_START_SEC

  Minimum elapsed time in seconds to trigger comeback bonus.

=back

=cut

our $ENABLE_DURATION_BONUS        = true;
our $DURATION_BONUS_MULTIPLIER    = 0.001;
our $DURATION_BONUS_START_SEC     = 60 * 60 * 3; # 3 hours
our $ENABLE_COMEBACK_BONUS        = true;
our $COMEBACK_BONUS_RATE          = 1.5;
our $COMEBACK_BONUS_START_SEC     = 60 * 60 * 24 * 2; # 2 days

=head1 METHODS

=head2 initial_character

  Returns the default data structure for a newly created character.

  Parameters:
    (None)

  HashRef: A hash reference containing the initial values for experience, level, generation, last update time, status attributes, and job assignment.

=cut

fun initial_character (ClassName $class) :Return(HashRef) {
    my $class = shift;
    my $job   = Games::Growth::Model::Character::Job->initial_job();
    my $status = +{
        agi => $DEFAULT_STATUS_VALUE,
        atk => $DEFAULT_STATUS_VALUE,
        def => $DEFAULT_STATUS_VALUE,
        ldr => $DEFAULT_STATUS_VALUE,
        skl => $DEFAULT_STATUS_VALUE,
        vit => $DEFAULT_STATUS_VALUE,
    };
    return +{
        experience         => 0,
        level              => 1,
        generation         => 0,
        last_updated_epoch => time(),
        resume             => [],
        status             => $status,
        job                => $job,
    };
}

=head2 apply_experience_bonus

  Calculates the final experience points to be added, based on the given base experience and time since last update.

  This method applies bonuses such as:
    - Login bonus for first message of the day
    - Comeback bonus if the user returns after a long absence
    - Duration-based bonus depending on the time elapsed since last activity

  Parameters:
    base_experience    => Int: The base experience points to start with.
    last_updated_epoch => Int: The UNIX epoch time of the last update.
    use_login_bonus    => Bool(optional): Whether to apply the login bonus.    Defaults to 1 (apply).
    use_comeback_bonus => Bool(optional): Whether to apply the comeback bonus. Defaults to 1 (apply).

  Returns:
    Int: The final experience value after applying applicable bonuses.

=head3 NOTE

  This method does not directly update the original exp.
  You are expected to apply the returned value to your data manually.

=cut

fun apply_experience_bonus(ClassName $class,
                           Int  :$base_experience,
                           Int  :$last_updated_epoch = time(),
                           Bool :$use_login_bonus    = $ENABLE_LOGIN_BONUS,
                           Bool :$use_duration_bonus = $ENABLE_DURATION_BONUS,
                           ) :Return(Int) {

    my $experience = $base_experience;

    # login bonus
    if($use_login_bonus) {
        my $last_update = localtime($last_updated_epoch);
        my $today       = localtime(time());
        # If the last update was yesterday, apply the login bonus
        if ($last_update->ymd ne $today->ymd) {
            $experience += $LOGIN_BONUS_EXPERIENCE;
        }
    }

    # duration bonus
    if($use_duration_bonus) {
        my $duration = (time() - $last_updated_epoch);
        if ($duration >= $DURATION_BONUS_START_SEC) {
            my $duration_bonus = $DURATION_BONUS_MULTIPLIER;
            # with Comeback bonus
            if($ENABLE_COMEBACK_BONUS && $duration >= $COMEBACK_BONUS_START_SEC){
                $experience += int($duration * $DURATION_BONUS_MULTIPLIER * $COMEBACK_BONUS_RATE);
            }
            # without Comeback bonus
            else {
                $experience += int($duration * $DURATION_BONUS_MULTIPLIER);
            }
        }
    }

    return $experience;
}

=head2 calculate_status

  Calculates the updated character level, status distribution, and job assignment based on experience points.

  This method takes a character's current state (including EXP, level, and status) and checks whether a level-up should occur.
  If so, it distributes status growth points accordingly, and re-evaluates the character's job based on updated stats.

  This method is pure and has no side effects. It does not mutate the input or perform file I/O.

  Parameters:
    HashRef $status: A hash reference representing the character's current state. See also initial_character()
      Required keys:
        experience         => Int: Total accumulated experience points.
        level              => Int: Current character level.
        generation         => Int: Current generation or reset count (retained, but not modified here).
        last_updated_epoch => Int: UNIX timestamp of last update (retained, but not modified here).
        resume             => ArrayRef: Array of job names the character has previously held.
        status             => HashRef: Hash of current stat values. Keys: atk, def, ldr, agi, vit, skl.
        job                => HashRef: Hash with current job information. Keys: name, score.

  Returns:
    HashRef: A new hash reference representing the updated character.
             Includes increased level, adjusted status, and updated job assignment.
             If no level-up occurred, returns empty hash.

=cut

fun calculate_status(ClassName $class, HashRef $character) :Return(HashRef) {
    my $updated           = clone($character);
    my $initial_character = $class->initial_character();
    my $level             = $character->{level};

    # level-up
    my $expect_level  = $class->_experience_to_level($character->{experience});
    $updated->{level} = $expect_level if $expect_level > $level;

    # growth status points
    my $character_status       = $character->{status};
    my $update_status_count    = (
        (
            sum(values %{ $initial_character->{status} }) +
            $class->_level_to_additional_status_points($expect_level)
        )
        - sum(values %$character_status)
    );
    if ($update_status_count > 0) {
        for (1.. $update_status_count) {
            my $target_status = [List::Util::shuffle(qw/atk def ldr agi vit skl/)]->[0];
            $updated->{status}->{$target_status}++;
        }
    }

    # any status exceeds the maximum value
    # return only generation
    my $is_ascend = $class->_is_ascend($updated->{status});
    if ($is_ascend) {
        my $generation = ($character->{generation} || 0) +1;
        return +{ generation => $generation };
    }

    # job assignment
    if(exists $updated->{status}){
        my $job_status = Games::Growth::Model::Character::Job->search_job($updated->{status});
        if(exists $job_status->{name}  &&
           exists $job_status->{score} &&
           (
               $job_status->{score} == -1                  || # -1 means special job, so always update
               $job_status->{score} > $updated->{job}->{score}
           )
        ){
            $updated->{job} = $job_status;
            push @{$updated->{resume}}, $job_status->{name} if $job_status->{name}
        }
    }
    return $updated;
}

=head1 PRIVATE METHODS

=head2 _experience_to_level

  Calculates the character's level based on accumulated experience points.

  This internal method uses a fixed threshold per level and assumes a
  linear progression. It is not intended for external use.

  Parameters:
    Int: The total experience points of the character.

  Returns:
    Int: The calculated level of the character.

=cut

sub _experience_to_level {
    my ($class, $experience) = @_;
    return int($experience / $EXPERIENCE_PER_LEVEL) + 1;
}

=head2 _level_to_additional_status_points

  Calculates the total number of status points a character should have based on their level.

  Parameters:
    integer: The level of the character.

  Returns:
    The total additional status points

=cut

sub _level_to_additional_status_points {
    my ($class, $level) = @_;
    return ($level - 1) * $STATUS_POINTS_PER_LEVEL;
}

=head2 _is_ascend

  Determines whether a character should ascend (i.e., reincarnate) based on their status values.

  Parameters:
    HashRef $status:  reference to a hash containing the character's status values.

  Returns:
    Bool: Returns true if any status value has reached or exceeded the maximum threshold, indicating the character should ascend; false otherwise.

=cut

sub _is_ascend {
    my ($class, $status) = @_;
    return max(values %$status) >= $MAX_STATUS_VALUE ? 1 : 0;
}

=head1 LICENSE

  This library is free software; you can redistribute it and/or modify
  it under the same terms as Perl itself.

=head1 AUTHOR

  Likkradyus Winston. E<lt>perl {at} li {dot} que {dot} jpE<gt>

=cut
