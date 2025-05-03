requires 'Function::Parameters';
requires 'Function::Return';
requires 'Types::Standard';
requires 'YAML::XS';

on 'develop' => sub {
    requires 'Data::Dumper';
    requires 'YAML';
};

on 'test' => sub {
    # ./xt layer
    requires 'Test::More';
    requires 'Test::Perl::Critic';
    requires 'Test::Pod';
    requires 'Test::Pod::Coverage';
    requires 'Test::Spelling';
};
