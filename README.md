# NAME

Data::Processor - Transform Perl Data Structures, Validate Data against a Schema, Produce Data from a Schema, or produce documentation directly from information in the Schema.

# SYNOPSIS

    use Data::Processor;
    my $schema = {
      section => {
          description => 'a section with a few members',
          error_msg   => 'cannot find "section" in config',
          members => {
              foo => {
                  # value restriction either with a regex..
                  value => qr{f.*},
                  description => 'a string beginning with "f"'
              },
              bar => {
                  # ..or with a validator callback.
                  validator => sub {
                      my $self   = shift;
                      my $parent = shift;
                      # undef is "no-error" -> success.
                      no strict 'refs';
                      return undef
                          if $self->{value} == 42;
                  }
              },
              wuu => {
                  optional => 1
              }
          }
      }
    };

    my $p = Data::Processor->new($schema);

    my $data = {
      section => {
          foo => 'frobnicate',
          bar => 42,
          # "wuu" being optional, can be omitted..
      }
    };

    my $error_collection = $p->validate($data, verbose=>0);
    # no errors :-)

# DESCRIPTION

Data::Processor is a tool for transforming, verifying, and producing Perl data structures from / against a schema, defined as a Perl data structure.

# METHODS

## new

    my $processor = Data::Processor->new($schema);

optional parameters:
\- indent: count of spaces to insert when printing in verbose mode. Default 4
\- depth: level at which to start. Default is 0.
\- verbose: Set to a true value to print messages during processing.

## validate
Validate the data against a schema. The schema either needs to be present
already or be passed as an argument.

    my $error_collection = $processor->validate($data, verbose=>0);

## validate\_schema

check that the schema is valid.
This method gets called upon creation of a new Data::Processor object.

    my $error_collection = $processor->validate_schema();

## merge\_schema

merges another schema into the schema (optionally at a specific node)

    my $error_collection = $processor->merge_schema($schema_2);

merging rules:
 - merging transformers will result in an error
 - merge checks if all merged elements match existing elements
 - non existing elements will be added from merging schema
 - validators from existing and merging schema get combined

## transform\_data

Transform one key in the data according to rules specified
as callbacks that themodule calls for you.
Transforms the data in-place.

    my $validator = Data::Processor::Validator->new($schema, data => $data)
    my $error_string = $processor->transform($key, $validator);

This is not tremendously useful at the moment, especially because validate()
transforms during validation.

## make\_data

Writes a data template using the information found in the schema.

    my $data = $processor->make_data(data=>$data);

## make\_pod

Write descriptive pod from the schema.

    my $pod_string = $processor->make_pod();

# AUTHOR

Matthias Bloch <matthias.bloch@puffin.ch>

# COPYRIGHT

Copyright 2015- Matthias Bloch

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
