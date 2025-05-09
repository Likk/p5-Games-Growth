package Games::Growth::Service::CharacterService;

use 5.40.0;
use utf8;

use Clone qw(clone);
use Function::Parameters;
use Function::Return;
use Hash::Diff;
use Types::Standard -types;

use Games::Growth::Model::Character;

# types
use constant {
    "Games::Growth::Service::CharacterService" => InstanceOf['Games::Growth::Service::CharacterService'],
};

=head1 NAME

  Games::Growth::Service::CharacterService - Service layer for operating game characters

=head1 SYNOPSIS

  use Games::Growth::Service::CharacterService;

  # new character
  my $service = Games::Growth::Service::CharacterService->new();
  $service->create_character('Alice');

  # input character
  my $service = Games::Growth::Service::CharacterService->new(
    character => $character
    name      => 'Bob'
  );

  # output character
  $name_with_character = $service->output_character();

  # gain experience
  $service->gain_experience(100);
  # level-up - status recalculation - gain job
  $service->calculate_status();

  # method chaining
  my $character = Games::Growth::Service::CharacterService->new()
          ->create_character('Alice')
          ->gain_experience(100)
          ->calculate_status()
          ->output_character();

=head1 DESCRIPTION

  This service class provides a simple interface for character operations,
  such as creation, gaining experience, applying bonuses, and recalculating status.

  Users are encouraged to feel free to use the domain model directly,
  but this service layer provides simplified interfaces as examples of common operations.

=head1 CONSTRUCTOR

=head2 new

  Creates a new instance of the service.

  Parameters:
    - %args: Optional arguments for initialization.

  Returns:
    Object: Games::Growth::Service::CharacterService

=cut

method new($class: %args) :Return(Games::Growth::Service::CharacterService) {
    my $self = bless {}, $class;
    $self->character($args{character}) if exists $args{character};
    $self->name($args{name})           if exists $args{name};
    return $self;
}

=head1 ACCESSORS

=head2 character

  Gets or sets the character object.

  Parameter/Returns:
    HashRef: A hash reference containing the initial values for experience, level, generation, last update time, status attributes, and job assignment.

  See also: Games::Growth::Model::Character
  +{
    experience      => Int:   The character's experience points.
    level           => Int:   The character's level.
    generation      => Int:   The character's generation.
    last_updated_at => Int:   The last update time (epoch).
    status          => HashRef: A hash reference containing the character's status attributes.
      +{
        atk => Int:  Attack power.
        def => Int:  Defense power.
        ldr => Int:  Leadership power.
        agi => Int:  Agility power.
        vit => Int:  Vitality power.
        skl => Int:  Skill power.
       }
    job_assignment  => HashRef: A hash reference containing the character's job assignment.
  }


=head2 name

  Gets or sets the name of the character.

  Parameter/Returns:
    Str: The name of the character.

=head2 updated_info

  Gets or sets the updated status of the character.

  Parameter/Returns:
    HashRef: A hash reference containing the character's status.

=cut

method character($self: HashRef $character = +{}) :Return(HashRef) {
    $self->{character} = $character if scalar keys %$character;
    return $self->{character};
}

method name($self: Str $name = '') :Return(Str) {
    $self->{name} = $name if $name;
    return $self->{name};
}

method updated_info($self: HashRef $updated_info = +{}) :Return(HashRef) {
    $self->{updated_info} = $updated_info if scalar keys %$updated_info;
    return $self->{updated_info} || +{};
}

=head1 METHODS

=head2 create_character

  Creates a new character with the given name.

  Parameters:
    Str $name: The name of the character.

  Returns:
    Games::Growth::Service::CharacterService: self, for method chaining.

=cut

method create_character($self: Str $name) :Return(Games::Growth::Service::CharacterService) {
    my $character = $self->{character} || +{};
    die "character already set" if $character && scalar keys %$character;

    $self->name($name);
    $self->character(
        Games::Growth::Model::Character->initial_character(),
    );
    return $self;
}

=head2 output_character

  Outputs the character's name and status.

  Parameters:
    (None)

  Returns:
    HashRef: A hash reference containing the character's name and status.
      name      => Str:    The character's name.
      character => Object: a Games::Growth::Model::Character object.

=cut

method output_character($self:) :Return(HashRef) {
    my ($character, $name);

    try {
        $character = $self->character();
    }
    catch($e) {
        die "character not set.: $e";
    }

    try {
        $name           = $self->name();
    }
    catch($e) {
        die "name not set.: $e";
    }

    my $updated_info = $self->updated_info();
    return +{
        name           => $name,
        character      => $character,
        updated_info => $self->updated_info,
    };
}

=head2 gain_experience

  Increases the character's experience points by the given amount.

  Parameters:
    Int $amount: The amount of experience to gain.

  Returns:
    self: The current instance of the service.

=cut

method gain_experience($self: Int $amount) :Return(Games::Growth::Service::CharacterService) {
    my $character;
    try {
        $character = $self->character();
    }
    catch($e) {
        die "character not set.: $e";
    }

    my $total_exp  = Games::Growth::Model::Character->apply_experience_bonus(
        base_experience    => $amount                          // 0,
        last_updated_epoch => $character->{last_updated_epoch} // time(),
        use_login_bonus    => 1,
        use_duration_bonus => 1,
    );
    $character->{experience}         += $total_exp;
    $character->{last_updated_epoch}  = time();
    $self->character($character);
    return $self;
}

=head2 calculate_status

  Recalculates the character's status based on the current experience points.

  Parameters:
    (None)

  Returns:
    self: The current instance of the service.

=cut

method calculate_status($self:) :Return(Games::Growth::Service::CharacterService) {
    my $character;
    try {
        $character = $self->character();
    }
    catch($e) {
        die "character not set.: $e";
    }

    my $updated = Games::Growth::Model::Character->calculate_status($character);

    # special case for ascension
    if($updated->{generation} != $character->{generation}) {
        # initialize experience, job, level and status
        my $ascended_character = Games::Growth::Model::Character->initial_character();
        # carry over generation, last_updated_epoch and resume
        $ascended_character->{last_updated_epoch} = clone($character->{last_updated_epoch});
        $ascended_character->{resume}             = clone($character->{resume});
        $ascended_character->{generation}         = $updated->{generation}; # incremented generation

        $self->character($ascended_character);
        $self->updated_info({generation => $updated->{generation}});
        return $self;
    }
    my $diff = Hash::Diff::diff($updated, $character);

    $self->character($updated);
    $self->updated_info($diff);
    return $self;
}
