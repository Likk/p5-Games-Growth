use 5.40.0;
use utf8;
use Games::Growth::Service::CharacterService;
binmode STDOUT, ":utf8";

=head1 NAME

  script.pl - A script to demonstrate the use of the CharacterService module.

=head1 SYNOPSIS

  cd p5-Games-Growth
  ./env.sh perl script.pl

=head1 NOTE

  This script is a demonstration of the CharacterService module.
  It creates a character, gains experience, calculates status, and outputs the character's information.

  This script is not include persistence features.
  Saving or loading character data (e.g., to/from a file or database) is not provided and should be implemented separately according to your environment.

=cut

binmode STDOUT, ":utf8";

my $service = Games::Growth::Service::CharacterService->new();
$service->create_character('Alice');
$service->gain_experience(16_000);
$service->calculate_status();
my $output = $service->output_character();

printf(":tada: level-up! to %s :tada:\n", $output->{updated_status}->{level}) if $output->{updated_status}->{level};
printf("update status: %s\n",
    join(", ",
        map { "$_ => $output->{updated_status}->{status}->{$_}" }
        keys %{$output->{updated_status}->{status}}
    )
) if $output->{updated_status}->{status};
printf("assigned job: %s\n", $output->{updated_status}->{job}->{name}) if $output->{updated_status}->{job}->{name};

print "---- current stauts ----", "\n";
print "Character Name: ",  $output->{name}, "\n";
print "Character Level: ", $output->{character}->{level}, "\n";
print "Character Status: \n";
print "  Attack: ",          $output->{character}->{status}->{atk}, "\n";
print "  Defense: ",         $output->{character}->{status}->{def}, "\n";
print "  Leadership: ",      $output->{character}->{status}->{ldr}, "\n";
print "  Agility: ",         $output->{character}->{status}->{agi}, "\n";
print "  Vitality: ",        $output->{character}->{status}->{vit}, "\n";
print "  Skill: ",           $output->{character}->{status}->{skl}, "\n";
