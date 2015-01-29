use strict;
use lib 'lib';
use Test::More;
use Data::Processor;

my $schema = {
    merge => {
        members => {
            number => {
                validator => sub {
                    my $value = shift;
                    return $value =~ /^[0-5]$/ ? undef : 'number from 0-5 expected';
                },
                description => 'number from 0-5',
            },
        },
    },
};

my $schema_2 = {
    number => {
        validator => sub {
            my $value = shift;
            return $value =~ /^\d$/ ? undef : 'number from 0-9 expected';
        },
    },
};

my $data = {
    merge => {
        number => 8,
    }
};

my $p = Data::Processor->new($schema);

my $error_collection = $p->merge_schema($schema_2, [ qw(merge members) ]);

ok ($error_collection->count == 0, '0 errors detected');

$error_collection = $p->validate($data, verbose=>0);

ok ($error_collection->count == 1, '1 error detected');

done_testing;

