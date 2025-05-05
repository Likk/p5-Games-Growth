package Games::Growth::Model::Character::Job;
use 5.40.0;
use autodie;
use utf8;

use Function::Parameters;
use Function::Return;
use Types::Standard -types;
use List::Util qw/shuffle min max/;

=head1 NAME

  Games::Growth::Model::Character::Job

=head1 DESCRIPTION

  Games::Growth::Model::Character::Job is a lightweight library designed for game development.
  It evaluates a character's status and determines an appropriate job (class) name based on specific status conditions.

  This library receives a character status structure from Games::Growth::Model::Character
  It checks if the character’s various parameters meet certain thresholds and, if they do, returns the corresponding job name.

  It is ideal for games that require:
    - Dynamic class assignment based on character growth
    - Automatic job (class) evaluation systems
    - Flexible and expandable class condition settings

=head1 USAGE

  This module is designed to be used in conjunction with the Games::Growth::Model::Character module.
  It provides a simple interface for determining a character's job based on their status parameters.

  The module is designed to be flexible and extensible, allowing users to customize job conditions and names as needed.

  To use this module, simply call the C<search_job> method with a hash reference containing the character's status parameters.

=head1 SYNOPSIS

  my $status = +{
    atk => 10,
    def => 5,
    ldr => 5,
    agi => 5,
    vit => 5,
    skl => 5,
  };
  my $job = Games::Growth::Model::Character::Job->search_job($status);
  print $job->{name}; # => "Striker"

=head1 PACKAGE GLOBAL VARIABLES

=head2 JOB_LIST

  JOB_LIST is defines the list of available jobs and the conditions for assigning them.
  Users are encouraged to freely customize the contents, especially the names arrays, to suit their game's flavor and design.

=head3 STRUCTURE

  $JOB_LIST is a hash reference with three main categories:
    - single:     Jobs based on a single dominant parameter
    - dual:       Jobs based on a combination of two dominant parameters
    - generalist: Jobs based on balanced growth across all parameters

  Each category has:
    - threshold_point: An array of points thresholds for determining job levels.
    - entries:         An array of job entry rules.
      - params:          An array of parameter names (e.g., ["atk"], ["atk", "def"]).
      - names:           An array of job names corresponding to the thresholds.

=head3 EXAMPLE

  If a character's atk reaches 8 points, they become an "Attacker."
  If it reaches 18, they become a "Braver," and so on.

  {
    threshold_point => [8, 18, 28, 38],
    entries => [
      { params => ["atk"], names => ["Attacker", "Braver",       "Berserker",   "Breaker"] },
      { params => ["def"], names => ["Defender", "Armor Knight", "Hoplomachus", "Paladin"] },
      ...
    ]
  }

=head3 IMPORTANT NOTES

  The names arrays are user-customizable. Feel free to rename or localize the job titles.
  The number of names should match or exceed the number of thresholds.
  If multiple jobs qualify, evaluation priority depends on the internal implementation order.

=cut

our $JOB_LIST = +{
    single => +{
        threshold_point => [8, 18, 28, 38],
        distance        => [1,  2,  4,  6],
        entries => [
            +{ params => [qw/atk/], names => [qw/Striker   Braveheart Berserker Ravager/  ]},
            +{ params => [qw/def/], names => [qw/Defender  Ironclad   Hoplite   Paladin/  ]},
            +{ params => [qw/ldr/], names => [qw/Enabler   Strategist Vanguard  Resonant/ ]},
            +{ params => [qw/agi/], names => [qw/Sprinter  Speedster  Phantom   Tempest/  ]},
            +{ params => [qw/vit/], names => [qw/Fighter   Warrior    Viking    Guardian/ ]},
            +{ params => [qw/skl/], names => [qw/Duelist   Assassin   Slayer    Executor/ ]},
        ],
    },
    dual => +{
        threshold_point => [12, 22, 42],
        distance        => [ 2,  3,  4],
        entries => [
            +{ params => [qw/atk def/], names => [qw/Brawler   Crusher     Destroyer/   ]},
            +{ params => [qw/atk ldr/], names => [qw/Striker   Smasher     Vanquisher/  ]},
            +{ params => [qw/atk agi/], names => [qw/Archer    Hunter      Sniper/      ]},
            +{ params => [qw/atk vit/], names => [qw/Burster   Skirmisher  Rampager/    ]},
            +{ params => [qw/atk skl/], names => [qw/Gladiator Champion    Swordmaster/ ]},
            +{ params => [qw/def ldr/], names => [qw/Shooter   Sweeper     Sentinel/    ]},
            +{ params => [qw/def agi/], names => [qw/Stormer   Interceptor Juggernaut/  ]},
            +{ params => [qw/def vit/], names => [qw/Tank      Fortress    Aegis/       ]},
            +{ params => [qw/def skl/], names => [qw/Debuffer  Phalanx     Unbreakable/ ]},
            +{ params => [qw/ldr agi/], names => [qw/Messenger Herald      Warbird/     ]},
            +{ params => [qw/ldr vit/], names => [qw/Supporter Soldier     Bastion/     ]},
            +{ params => [qw/ldr skl/], names => [qw/Buffer    Signmaker   Tactician/   ]},
            +{ params => [qw/agi vit/], names => [qw/Scout     Ranger      Survivor/    ]},
            +{ params => [qw/agi skl/], names => [qw/Thief     Assassin    Eraser/      ]},
            +{ params => [qw/vit skl/], names => [qw/Binder    Counter     Trickster/   ]},
        ],
    },
    generalist => +{
        threshold_point => [10, 20, 30, 40],
        distance        => [3,   5,  5,  5], # max - min
        entries => [ #all parameter
            +{ params => [qw//], names => [qw/Balancer Harmonizer Polymath Hero/]},
        ],
    },
};


=head2 INITIAL_JOB

  A global hashref defining the default job assigned to a new character.
  This value can be customized by the user to define their own starting job configuration. It must contain a C<name> (String) and a C<score> (Int).

  Default value:
     $INITIAL_JOB = {
        name  => 'Adventurer',
        score => 0,
     }

  This is used when a new character is initialized and no prior job history exists.

=cut

our $INITIAL_JOB = +{
    name  => 'Adventurer',
    score => 0,
};

=head1 METHODS

=head2 initial_job

  Returns the initial job configuration defined in the package-level variable C<$INITIAL_JOB>.

  This method provides a consistent and centralized way to retrieve the default job assigned to newly created characters. The contents of C<$INITIAL_JOB> are intended to be customizable by the user, allowing for flexible definitions of job name and initial score.

  Parameters:
    (None)

  Returns:
    HashRef: A hash reference containing the initial job name and score.
      name  => String: The name of the job.
      score => Int:    The score associated with the job.

=cut

fun initial_job(ClassName $class) :Return(HashRef) {
    return $INITIAL_JOB;
}

=head2 search_job

  search_job() evaluates a character's status and determines the most suitable job based on predefined conditions.
  It checks for three types of job matches - dual-professional, single-professional, and generalist - and returns the job with the highest score.

  Parameters:
    HashRef $status: A hash reference containing the character's status parameters.

  Returns:
    HashRef: A hash reference containing the job name and score.
      name  => String: The name of the job.
      score => Int:    The score associated with the job.

=cut

fun search_job(ClassName $class, HashRef $status) :Return(HashRef) {
    my $job_list = [];
    {
        my $job_status = $class->search_single_professional($status);
        push @$job_list, $job_status if exists $job_status->{name};
    }
    {
        my $job_status = $class->search_dual_professional($status);
        push @$job_list, $job_status if exists $job_status->{name};
    }
    {
        my $job_status = $class->search_generalist($status);
        push @$job_list, $job_status if exists $job_status->{name};
    }

    # 3タイプのスコアが被ることはないはず
    for my $job (sort { $b->{score} <=> $a->{score} } @$job_list) {
        return +{
            name =>  $job->{name},
            score => $job->{score},
        };
    }
    return +{}
}

=head2 search_single_professional

  search_single_professional() evaluates the character's status to find a single-professional job specialization.
  A parameter (e.g., atk, def, ldr, agi, vit, skl)  is eligible if:
     1. It exceeds the defined threshold value.
     2. The difference between the parameter and the average of the other parameters exceeds a defined distance.

  Parameters:
    HashRef $status: A hash reference containing the character's status parameters.

  Returns:
    HashRef: A hash reference containing the job name, score, and evaluated status.
      name   => String: The name of the matched job.
      score  => Int:    The threshold score associated with the job.
      status => Int:    The character's actual parameter value used for matching.
  If no job matches, returns undef.

=head3 NOTE

  - A parameter is considered a valid candidate only if:
      - It exceeds its corresponding threshold value.
      - It differs from the average of all parameters by at least the configured distance.
  - If multiple jobs match, the one with the highest score is chosen.
  - If scores are tied, the one with the higher parameter value is selected.
  - If still tied, one is randomly selected.

=cut

sub search_single_professional {
    my ($class, $status) = @_;
    my $job_list = [];
    my $entries         = $JOB_LIST->{single}->{entries};
    my $threshold_point = $JOB_LIST->{single}->{threshold_point};
    my $distance        = $JOB_LIST->{single}->{distance};

    for my $entry (@$entries) {
        my $params = $entry->{params};
        my $names  = $entry->{names};

        my $avg = List::Util::sum(
            map { $status->{$_} }
            grep { $_ ne $params->[0] }
            keys %$status
        ) / ((scalar keys %$status) - 1 || 5);

        push @$job_list, +{
            name   => $names->[3],
            status => $status->{$params->[0]},
            score  => $threshold_point->[3],
        } if (
            $status->{$params->[0]} >= $threshold_point->[3] &&
            $status->{$params->[0]} - $avg >= $distance->[3]
        );
        push @$job_list, +{
            name   => $names->[2],
            status => $status->{$params->[0]},
            score  => $threshold_point->[2],
        } if (
            $status->{$params->[0]} >= $threshold_point->[2] &&
            $status->{$params->[0]} - $avg >= $distance->[2]
        );
        push @$job_list, +{
            name   => $names->[1],
            status => $status->{$params->[0]},
            score  => $threshold_point->[1],
        } if (
            $status->{$params->[0]} >= $threshold_point->[1] &&
            $status->{$params->[0]} - $avg >= $distance->[1]
        );
        push @$job_list, +{
            name   => $names->[0],
            status => $status->{$params->[0]},
            score  => $threshold_point->[0],
        } if (
            $status->{$params->[0]} >= $threshold_point->[0] &&
            $status->{$params->[0]} - $avg >= $distance->[0]
        );
    }

    return undef if scalar @$job_list == 0;

    $job_list = [
        sort {
            $b->{score}  <=> $a->{score}  ||
            $b->{status} <=> $a->{status} ||
            rand()       <=> rand()
        } @$job_list
    ];
    return $job_list->[0];
}

=head2 search_dual_professional

  search_dual_professional() evaluates a character's status and determines a job suited for characters specialized in two parameters.
  It checks combinations of two status parameters (e.g., atk and def) against predefined threshold values and selects the highest scoring job if the conditions are met.

  Parameters:
    HashRef $status: A hash reference containing the character's status parameters.

  Returns:
    HashRef: A hash reference containing the job name and score.
      name => String: The name of the matched job.
      score => Int: The score associated with the job.

=head3 NOTE

  - Both of the selected two parameters must exceed the defined threshold.
  - The average of the remaining four parameters must differ from both selected parameters by at least a defined distance.
  - If multiple jobs match, the one with the highest score is chosen.
  - If scores are tied, one is randomly selected.

=cut

sub search_dual_professional {
    my ($class, $status) = @_;
    my $job_list = [];
    my $entries         = $JOB_LIST->{dual}->{entries};
    my $threshold_point = $JOB_LIST->{dual}->{threshold_point};
    my $distance        = $JOB_LIST->{dual}->{distance};

    for my $entry (@$entries) {
        my $params = $entry->{params};
        my $names  = $entry->{names};

        my $avg = List::Util::sum(
            map { $status->{$_} }
            grep { $_ ne $params->[0] && $_ ne $params->[1] }
            keys %$status
        ) / ((scalar keys %$status) - 2 || 5);

        push @$job_list, +{
            name   => $names->[2],
            status => $status->{$params->[0]} + $status->{$params->[1]},
            score  => $threshold_point->[2],
        } if (
            $status->{$params->[0]} >= $threshold_point->[2] &&
            $status->{$params->[1]} >= $threshold_point->[2] &&
            $status->{$params->[0]} - $avg >= $distance->[2] &&
            $status->{$params->[1]} - $avg >= $distance->[2]
        );

        push @$job_list, +{
            name   => $names->[1],
            status => $status->{$params->[0]} + $status->{$params->[1]},
            score  => $threshold_point->[1],
        } if (
            $status->{$params->[0]} >= $threshold_point->[1] &&
            $status->{$params->[1]} >= $threshold_point->[1] &&
            $status->{$params->[0]} - $avg >= $distance->[1] &&
            $status->{$params->[1]} - $avg >= $distance->[1]
        );
        push @$job_list, +{
            name   => $names->[0],
            status => $status->{$params->[0]} + $status->{$params->[1]},
            score  => $threshold_point->[0],
        } if (
            $status->{$params->[0]} >= $threshold_point->[0] &&
            $status->{$params->[1]} >= $threshold_point->[0] &&
            $status->{$params->[0]} - $avg >= $distance->[0] &&
            $status->{$params->[1]} - $avg >= $distance->[0]
        );
    }

    return +{} if scalar @$job_list == 0;

    $job_list = [
        sort {
            $b->{score}  <=> $a->{score}  ||
            $b->{status} <=> $a->{status} ||
            rand()       <=> rand()
        } @$job_list
    ];
    return $job_list->[0];
}

=head2 search_generalist

  search_generalist() evaluates a character's overall balance of status parameters and determines a generalist-type job.

  Parameters:
    HashRef $status: A hash reference containing the character's status parameters.

  Returns:
    HashRef: A hash reference containing the job name and score.
      name  => String: The name of the matched job.
      score => Int:    The score associated with the job.

=head3 Note:

  The selection criteria for generalist jobs differ from single- and dual-professional jobs.
    - The evaluation focuses on the minimum parameter value rather than specific parameters.
    - The difference between the maximum and minimum parameter values is also considered.
    - To qualify for generalist jobs, the following must apply
      - The minimum parameter must exceed a defined threshold.
      - The range between the highest and lowest values must be within a specified distance.
        - Distance requirements vary by job rank, typically ranging from 3 to 5 points.

=cut

sub search_generalist {
    my ($class, $status) = @_;
    my $job_list = [];

    my $entries         = $JOB_LIST->{generalist}->{entries};
    my $threshold_point = $JOB_LIST->{generalist}->{threshold_point};
    my $distance        = $JOB_LIST->{generalist}->{distance};
    my $min = List::Util::min(values %$status);
    my $max = List::Util::max(values %$status);

    push @$job_list , +{
        name  => $entries->[0]->{names}->[3],
        score => $threshold_point->[3],
    } if (
        $min        >= $threshold_point->[3] &&
        $max - $min <= $distance->[3]
    );

    push @$job_list , +{
        name  => $entries->[0]->{names}->[2],
        score => $threshold_point->[2],
    } if (
        $min        >= $threshold_point->[2] &&
        $max - $min <= $distance->[2]
    );

    push @$job_list , +{
        name  => $entries->[0]->{names}->[1],
        score => $threshold_point->[1],
    } if (
        $min        >= $threshold_point->[1] &&
        $max - $min <= $distance->[1]
    );

    push @$job_list , +{
        name  => $entries->[0]->{names}->[0],
        score => $threshold_point->[0],
    } if (
        $min >= $threshold_point->[0] &&
        $max - $min <= $distance->[0]
    );

    return +{} if scalar @$job_list == 0;

    $job_list = [
        sort {
            $b->{score} <=> $a->{score} ||
            rand()      <=> rand()
        } @$job_list
    ];
    return $job_list->[0];
}
