# NAME                          

Games::Growth::Model::Character - A character growth and status management module

# DESCRIPTION                   

Games::Growth::Model::Character is a character status and growth model.  

This class manages the data and logic associated with a character.
It represents a character's attributes and behaviors in a game or simulation.
Specifically, it handles the character's status (such as atk, def, agi, etc.), growth system (including jobs, level-ups, and stat progression), and other character-specific information.  

HP and MP are not supported. Instead, this class uses vit (durability) and skl (skill) parameters to derive various aspects of character capability.  

# USAGE                         

This module is designed to be used in a game or simulation context.
It provides methods for managing character attributes, growth, and status effects.  

The module is intended for use by developers creating games or simulations that require character management.  

# SEE ALSO                      

- Games::Growth::Model::Character
- Games::Growth::Model::Character::Job  

# SET UP

## install perl lib
```
git clone git@github.com:Likk/p5-Games-Growth
$ cd ./p5-Games-Growth
$ anyenv install plenv
$ cat .perl-version | xargs plenv install
$ ./env.sh plenv install-cpanm
$ ./env.sh cpanm App::cpm
$ ./env.sh cpm install
```
